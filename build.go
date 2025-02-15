// Copyright 2018-2021 (c) Cognizant Digital Business, Evolutionary AI. All rights reserved. Issued under the Apache 2.0 License.

package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path"
	"path/filepath"
	"sort"
	"strings"

	runner "github.com/leaf-ai/studio-go-runner/internal/runner"

	"github.com/karlmutch/duat"
	"github.com/karlmutch/duat/version"
	logxi "github.com/karlmutch/logxi/v1"

	"github.com/go-stack/stack"
	"github.com/jjeffery/kv" // MIT License

	"github.com/karlmutch/envflag"

	"github.com/go-enry/go-license-detector/v4/licensedb"
	"github.com/go-enry/go-license-detector/v4/licensedb/filer"
)

var (
	logger = logxi.New("build.go")

	verbose     = flag.Bool("v", false, "Print internal logging for this tool")
	shortTests  = flag.Bool("short", false, "Enable only the short tests")
	recursive   = flag.Bool("r", false, "Visit any sub directories that contain main functions and build in each")
	userDirs    = flag.String("dirs", ".", "A comma separated list of root directories that will be used a starting points looking for Go code, this will default to the current working directory")
	githubToken = flag.String("github-token", "", "If set this will automatically trigger a release of the binary artifacts to github at the current version")
	buildLog    = flag.String("runner-build-log", "", "The location of the build log used by the invoking script, to be uploaded to github")
	releaseOnly = flag.Bool("release-only", false, "Perform the github release only")
)

func usage() {
	fmt.Fprintln(os.Stderr, path.Base(os.Args[0]))
	fmt.Fprintln(os.Stderr, "usage: ", os.Args[0], "[options]       build tool (build.go)      ", version.GitHash, "    ", version.BuildTime)
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintln(os.Stderr, "Arguments")
	fmt.Fprintln(os.Stderr, "")
	flag.PrintDefaults()
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintln(os.Stderr, "Environment Variables:")
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintln(os.Stderr, "options can also be extracted from environment variables by changing dashes '-' to underscores and using upper case.")
	fmt.Fprintln(os.Stderr, "")
	fmt.Fprintln(os.Stderr, "log levels are handled by the LOGXI env variables, these are documented at https://github.com/mgutz/logxi")
}

func init() {
	flag.Usage = usage
}

func main() {
	// This code is run in the same fashion as a script and should be co-located
	// with the component that is being built

	// Parse the CLI flags
	if !flag.Parsed() {
		envflag.Parse()
	}

	if *verbose {
		logger.SetLevel(logxi.LevelDebug)
	}

	// First assume that the directory supplied is a code directory
	rootDirs := strings.Split(*userDirs, ",")
	execDirs := []string{}

	// If this is a recursive build scan all inner directories looking for go code.
	// Skip the vendor directory and when looking for code examine to see if it is
	// test code, or go generate style code.
	//
	// Build any code that is found and respect the go generate first.
	//
	if *recursive {
		for _, dir := range rootDirs {
			// Dont allow the vendor directory to creep in
			if filepath.Base(dir) == "vendor" {
				continue
			}

			// Otherwise look for meanful code that can be run either as tests
			// or as a standard executable
			// Will auto skip any vendor directories found
			dirs, err := duat.FindGoDirs(dir, []string{"main", "TestMain"})
			if err != nil {
				logger.Warn(err.Error(), "stack", stack.Trace().TrimRuntime())
				os.Exit(-1)
			}
			execDirs = append(execDirs, dirs...)
		}
	} else {
		execDirs = rootDirs
	}

	// Now remove duplicates within the list of directories that we can potentially
	// visit during builds, removing empty strings
	{
		lastSeen := ""
		deDup := make([]string, 0, len(execDirs))
		sort.Strings(execDirs)
		for _, dir := range execDirs {
			if dir != lastSeen {
				deDup = append(deDup, dir)
				lastSeen = dir
			}
		}
		execDirs = deDup
	}

	licensesManifest()

	if !*releaseOnly {
		// Invoke the generator in any of the root dirs and their desendents without
		// looking for a main for TestMain as generated code can exist throughout any
		// of our repos packages
		if outputs, err := runGenerate(rootDirs, "README.md"); err != nil {
			for _, aLine := range outputs {
				logger.Info(aLine)
			}
			logger.Warn(err.Error(), "stack", stack.Trace().TrimRuntime())
			os.Exit(-3)
		}

		// Take the discovered directories and build them from a deduped
		// directory set
		for _, dir := range execDirs {
			if outputs, err := runBuild(dir, "README.md"); err != nil {
				for _, aLine := range outputs {
					logger.Info(aLine)
				}
				logger.Warn(err.Error(), "stack", stack.Trace().TrimRuntime())
				os.Exit(-4)
			}
		}
	}
	outputs := []string{}

	checkFresh := true
	for _, dir := range execDirs {
		localOut, err := runRelease(dir, "README.md", checkFresh)
		if err != nil {
			logger.Warn(err.Error(), "stack", stack.Trace().TrimRuntime())
			os.Exit(-5)
		}
		checkFresh = false
		outputs = append(outputs, localOut...)
	}
	logger.Debug(fmt.Sprintf("built %s %v", strings.Join(outputs, ", "), stack.Trace().TrimRuntime()))

	for _, output := range outputs {
		fmt.Fprintln(os.Stdout, output)
	}
}

type License struct {
	lic   string
	score float32
}

func licensesManifest() {
	allLics, err := licenses(".")
	if err != nil {
		logger.Warn(kv.Wrap(err, "could not create a license manifest").With("stack", stack.Trace().TrimRuntime()).Error())
	}
	licf, errGo := os.OpenFile("licenses.manifest", os.O_WRONLY|os.O_CREATE, 0644)
	if errGo != nil {
		logger.Warn(kv.Wrap(errGo, "could not create a license manifest").With("stack", stack.Trace().TrimRuntime()).Error())
	} else {
		lines := make([]string, 0, len(allLics))
		for dir, lics := range allLics {
			lines = append(lines, fmt.Sprint(dir, ",", lics[0].lic, ",", lics[0].score, "\n"))
		}
		sort.Strings(lines)
		for _, aLine := range lines {
			licf.WriteString(aLine)
		}
		licf.Close()
	}
}

// licenses returns a list of directories and files that have license and confidences related to
// each.  An attempt is made to rollup results so that directories with licenses that match all
// files are aggregated into a single entry for the items, any small variations for files are
// called out and left in the output.  Also directories are rolled up where their children match.
//
func licenses(dir string) (lics map[string][]License, err kv.Error) {
	lics = map[string][]License{}
	errGo := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if !info.IsDir() {
			return nil
		}
		if len(path) > 1 && path[0] == '.' {
			return filepath.SkipDir
		}
		fr, errGo := filer.FromDirectory(path)
		if errGo != nil {
			return kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
		}
		licenses, errGo := licensedb.Detect(fr)
		if errGo != nil && errGo.Error() != "no license file was found" {
			return kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
		}
		if len(licenses) == 0 {
			return nil
		}
		if _, isPresent := lics[path]; !isPresent {
			lics[path] = []License{}
		}
		for lic, match := range licenses {
			lics[path] = append(lics[path], License{lic: lic, score: match.Confidence})
		}
		sort.Slice(lics[path], func(i, j int) bool { return lics[path][i].score < lics[path][j].score })
		return nil
	})
	if errGo != nil {
		return nil, kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}
	return lics, nil
}

// runGenerate is used to do a stock go generate within our project directories
//
func runGenerate(dirs []string, verFn string) (outputs []string, err kv.Error) {

	for _, dir := range dirs {
		files, err := duat.FindGoGenerateDirs([]string{dir}, []string{})
		if err != nil {
			fmt.Fprintln(os.Stderr, err.Error())
			os.Exit(-6)
		}

		genFiles := make([]string, 0, len(files))
		for _, fn := range files {

			// Will skip any vendor directories found
			if strings.Contains(fn, "/vendor/") || strings.HasSuffix(fn, "/vendor") {
				continue
			}

			genFiles = append(genFiles, fn)
		}

		outputs, err = func(dir string, verFn string) (outputs []string, err kv.Error) {
			// Switch to the targets directory while the build is being done.  The defer will
			// return us back to ground 0
			cwd, errGo := os.Getwd()
			if errGo != nil {
				return outputs, kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
			}
			defer func() {
				if errGo = os.Chdir(cwd); errGo != nil {
					logger.Warn("The original directory could not be restored after the build completed")
					if err == nil {
						err = kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
					}
				}
			}()

			// Gather information about the current environment. also changes directory to the working area
			md, err := duat.NewMetaData(cwd, verFn)
			if err != nil {
				return outputs, err
			}

			if outputs, err = generate(md, genFiles); err != nil {
				return outputs, err
			}
			return outputs, nil
		}(dir, verFn)
		if err != nil {
			return outputs, err.With("dir", dir)
		}
	}
	return outputs, nil
}

// runBuild is used to restore the current working directory after the build itself
// has switched directories
//
func runBuild(dir string, verFn string) (outputs []string, err kv.Error) {

	logger.Info(fmt.Sprintf("visiting %s", dir))

	// Switch to the targets directory while the build is being done.  The defer will
	// return us back to ground 0
	cwd, errGo := os.Getwd()
	if errGo != nil {
		return outputs, kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}
	defer func() {
		if errGo = os.Chdir(cwd); errGo != nil {
			logger.Warn("The original directory could not be restored after the build completed")
			if err == nil {
				err = kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
			}
		}
	}()

	// Gather information about the current environment. also changes directory to the working area
	md, err := duat.NewMetaData(dir, verFn)
	if err != nil {
		return outputs, err
	}

	// Testing first will speed up failing in the event of a compiler or functional issue
	if err == nil {
		logger.Info(fmt.Sprintf("testing %s", dir))
		out, errs := test(md)
		outputs = append(outputs, out...)
		if len(errs) != 0 {
			return outputs, errs[0]
		}
	}

	logger.Info(fmt.Sprintf("building %s", dir))
	outputs, err = build(md)
	if err != nil {
		return outputs, err
	}

	return outputs, err
}

// runRelease will take the existing checked out source tree and tag a github release for it.
//
func runRelease(dir string, verFn string, checkFresh bool) (outputs []string, err kv.Error) {

	outputs = []string{}

	cwd, errGo := os.Getwd()
	if errGo != nil {
		return outputs, kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}
	defer func() {
		if errGo = os.Chdir(cwd); errGo != nil {
			logger.Warn("The original directory could not be restored after the build completed")
			if err == nil {
				err = kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
			}
		}
	}()

	// Gather information about the current environment. also changes directory to the working area
	md, err := duat.NewMetaData(dir, verFn)
	if err != nil {
		return outputs, err
	}

	if len(*githubToken) != 0 {

		if _, errGo := os.Stat("./bin"); errGo == nil {
			if outputs, err = md.GoFetchBuilt(); err != nil {
				return outputs, err
			}
		}

		// Add to the release a build log if one was being generated
		if len(*buildLog) != 0 && len(outputs) != 0 {
			log, errGo := filepath.Abs(filepath.Join(cwd, *buildLog))
			if errGo == nil {
				// sync the filesystem, blindly
				cmd := exec.Command("sync")
				// Wait for it to stop and ignore the result
				_ = cmd.Run()
				if fi, errGo := os.Stat(log); errGo == nil {
					if fi.Size() > 0 {
						outputs = append(outputs, log)
					} else {
						logger.Warn(kv.NewError("empty log").With("log", log).With("stack", stack.Trace().TrimRuntime()).Error())
					}
				} else {
					logger.Warn(kv.Wrap(errGo).With("log", log).With("stack", stack.Trace().TrimRuntime()).Error())
				}
			} else {
				logger.Warn(kv.Wrap(errGo).With("log", log).With("stack", stack.Trace().TrimRuntime()).Error())
			}
		}

		if len(outputs) != 0 {
			logger.Info(fmt.Sprintf("%s github releasing %s", md.SemVer.String(), outputs))
			released := []string{}
			released, err = md.HasReleased(*githubToken, "", outputs)
			if err == nil {
				if len(released) != 0 {
					if checkFresh {
						err = kv.NewError("already released").With("released", released).With("stack", stack.Trace().TrimRuntime())
					}
				} else {
					err = md.CreateRelease(*githubToken, "", outputs)
				}
			}
		}
	} else {
		logger.Debug("GITHUB_TOKEN was not found do not release", stack.Trace().TrimRuntime().String())
	}

	return outputs, err
}

func generate(md *duat.MetaData, files []string) (outputs []string, err kv.Error) {
	for _, file := range files {
		logger.Info("generating " + file)
		osEnv := os.Environ()
		env := make(map[string]string, len(osEnv))
		for _, evar := range os.Environ() {
			pair := strings.SplitN(evar, "=", 2)
			env[pair[0]] = pair[1]
		}
		if outputs, err = md.GoGenerate(file, env, []string{}, []string{}); err != nil {
			return outputs, err
		}
	}
	return nil, nil
}

// build performs the default build for the component within the directory specified, but does
// no further than producing binaries that need to be done within a isolated container
//
func build(md *duat.MetaData) (outputs []string, err kv.Error) {

	// Before beginning purge the bin directory into which our files are saved
	// for downstream packaging etc
	//
	errGo := os.RemoveAll("./bin")
	if errGo != nil {
		return nil, kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}
	if errGo = os.MkdirAll("./bin", os.ModePerm); errGo != nil {
		return nil, kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}

	opts := []string{
		"-a",
		"--mod=vendor",
		"-ldflags=\"-extldflags=-static\"",
	}

	// Do the NO_CUDA executable first as we dont want to overwrite the
	// executable that uses the default output file name in the build
	targets, err := md.GoBuild([]string{"NO_CUDA", "osusergo", "netgo"}, opts, "./bin", "cpu", false)
	if err != nil {
		return nil, err
	}

	outputs = append(outputs, targets...)

	// Do a GPU based build that leverages CUDA, only if it is found
	if !CudaPresent() {
		return outputs, nil
	}
	if ldPath := findNVML(); len(ldPath) != 0 {
		opts = append(opts, "-ldflags \"-L"+ldPath+" -lnvidia-ml\"")
	}

	if targets, err = md.GoBuild([]string{}, opts, "./bin", "", false); err != nil {
		return nil, err
	}
	outputs = append(outputs, targets...)

	return outputs, nil
}

func findFiles(patterns []string) (found []string) {

	for _, v := range patterns {
		// Getting an error is largely meaningless here because there is no action
		// that is a useful mitigation
		matches, _ := filepath.Glob(v)

		found = append(found, matches...)
	}
	return found
}

func findNVML() (location string) {
	libPaths := strings.Split(os.Getenv("LD_LIBRARY_PATH"), ":")
	filepath.Walk("/usr/lib", func(path string, info os.FileInfo, err error) error {
		if info.IsDir() {
			libPaths = append(libPaths, path)
		}
		return nil
	})
	for _, aPath := range libPaths {
		if matches := findFiles([]string{filepath.Join(aPath, "libnvidia-ml.so*")}); len(matches) != 0 {
			return aPath
		}
	}
	return ""
}

func CudaPresent() bool {
	// Get any default directories from the linux env var that is used for shared libraries
	libPaths := strings.Split(os.Getenv("LD_LIBRARY_PATH"), ":")
	filepath.Walk("/usr/lib", func(path string, info os.FileInfo, err error) error {
		if info.IsDir() {
			libPaths = append(libPaths, path)
		}
		return nil
	})
	for _, aPath := range libPaths {
		if _, errGo := os.Stat(filepath.Join(aPath, "libcuda.so.1")); errGo == nil {
			return true
		}
	}
	return false
}

func GPUPresent() bool {
	if _, errGo := os.Stat("/dev/nvidiactl"); errGo != nil {
		return false
	}
	if _, errGo := os.Stat("/dev/nvidia0"); errGo != nil {
		return false
	}
	// TODO We can check for a GPU by using nvidia-smi -L
	return true

}

func k8sPod() (isPod bool, err kv.Error) {

	fn := "/proc/self/mountinfo"

	contents, errGo := ioutil.ReadFile(fn)
	if errGo != nil {
		return false, kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime()).With("file", fn)
	}
	for _, aMount := range strings.Split(string(contents), "\n") {
		fields := strings.Split(aMount, " ")
		// For information about the individual fields c.f. https://www.kernel.org/doc/Documentation/filesystems/proc.txt
		if len(fields) > 5 {
			if fields[4] == "/run/secrets/kubernetes.io/serviceaccount" {
				return true, nil
			}
		}
	}
	return false, nil
}

// test inspects directories within the project that contain test cases, implemented
// using the standard go build _test.go file names, and runs those tests that
// the hardware provides support for
//
func test(md *duat.MetaData) (outputs []string, errs []kv.Error) {

	// Go through the directories looking for test files
	testDirs := []string{}
	rootDirs := []string{"."}

	// If this is a recursive build scan all inner directories looking for go code
	// and save these somewhere for us to comeback and look for test code
	//
	if *recursive {
		dirs := []string{}
		for _, dir := range rootDirs {
			// Will auto skip any vendor directories found
			found, err := duat.FindGoDirs(dir, []string{"TestMain"})
			if err != nil {
				fmt.Fprintln(os.Stderr, err.Error())
				os.Exit(-7)
			}
			dirs = append(dirs, found...)
		}
		rootDirs = dirs
	}

	for _, dir := range rootDirs {
		files, errGo := ioutil.ReadDir(dir)
		if errGo != nil {
			errs = append(errs,
				kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime()).With("dir", dir).With("rootDirs", rootDirs))
		}

		for _, file := range files {
			if file.IsDir() {
				continue
			}
			if strings.HasSuffix(file.Name(), "_test.go") {
				testDirs = append(testDirs, dir)
				break
			}
			// TODO Check for the test flag using the go AST, too heavy weight
			// for our purposes at this time
		}
	}

	masterVars := os.Environ()
	envVars := make(map[string]string, len(masterVars))
	envVars["LOGXI"] = "*=INF"

	opts := []string{
		"-a",
		"-v",
	}
	tags := []string{}

	// Look for the Kubernetes is present indication and disable
	// tests if it is not
	sPod, _ := k8sPod()
	if !sPod {
		opts = append(opts, "-test.short")
		opts = append(opts, "-test.timeout=20m")
	} else {
		if *shortTests {
			opts = append(opts, "-test.short")
		}
		opts = append(opts, "-test.timeout=30m")
		envVars["USE_K8S"] = "TRUE"
	}

	if !GPUPresent() {
		// Look for GPU Hardware and set the build flags for the tests based
		// on its presence
		envVars["NO_GPU"] = "TRUE"
		opts = append(opts, "-ldflags=\"-extldflags=-static\"")
		tags = append(tags, "NO_CUDA")
		tags = append(tags, "osusergo")
		tags = append(tags, "netgo")
	}

	// Now run go test in all of the the detected directories
	for _, dir := range testDirs {
		err := func() (err kv.Error) {
			cwd, errGo := os.Getwd()
			if errGo != nil {
				return kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
			}
			defer func() {
				if errGo = os.Chdir(cwd); errGo != nil {
					if err == nil {
						err = kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
					}
				}
			}()
			if errGo = os.Chdir(filepath.Join(cwd, dir)); errGo != nil {
				return kv.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
			}

			// Introspect the system under test for CLI scenarios, if none then just do a single run
			allOpts, err := runner.GoGetConst(dir, "DuatTestOptions")
			if err != nil {
				return err
			}
			if allOpts == nil {
				return kv.NewError("could not find 'var DuatTestOptions [][]string'").With("var", "DuatTestOptions").With("stack", stack.Trace().TrimRuntime())
			}

			// Get the logging environment variables and duplicate these into the build test environment
			for _, v := range masterVars {
				if strings.HasPrefix(v, "LOGXI") {
					kv := strings.SplitN(v, "=", 2)
					envVars[kv[0]] = kv[1]
				}
			}

			for _, appOpts := range allOpts {
				cliOpts := append(opts, appOpts...)
				if err = md.GoTest(envVars, tags, cliOpts); err != nil {
					return err
				}
			}
			return nil
		}()
		if err != nil {
			errs = append(errs, err)
		}
	}
	return outputs, errs
}
