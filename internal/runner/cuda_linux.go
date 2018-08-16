// +build !NO_CUDA

package runner

// This file contains the implementation and interface code for the CUDA capable devices
// that are provisioned on a system

import (
	"github.com/NVIDIA/gpu-monitoring-tools/bindings/go/nvml"

	"github.com/go-stack/stack"
	"github.com/karlmutch/errors"
)

var (
	initErr errors.Error
)

func init() {
	if errGo := nvml.Init(); errGo != nil {
		initErr = errors.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}
}

func HasCUDA() bool {
	return true
}

func getCUDAInfo() (outDevs cudaDevices, err errors.Error) {

	// Dont let the GetAllGPUs log a fatal error catch it first
	if initErr != nil {
		return outDevs, initErr
	}

	cnt, errGo := nvml.GetDeviceCount()
	if errGo != nil {
		return outDevs, errors.Wrap(errGo).With("stack", stack.Trace().TrimRuntime())
	}

	outDevs = cudaDevices{Devices: make([]device, 0, cnt)}
	if err != nil {
		return outDevs, err
	}

	for i, _ := range outDevs.Devices {

		dev, errGo := nvml.NewDevice(uint(i))
		if errGo != nil {
			return cudaDevices{}, errors.Wrap(errGo).With("device", i).With("stack", stack.Trace().TrimRuntime())
		}

		status, errGo := dev.Status()
		if errGo != nil {
			return cudaDevices{}, errors.Wrap(errGo).With("model", dev.Model).With("UUID", dev.UUID).With("device", i).With("stack", stack.Trace().TrimRuntime())
		}

		mem := status.Memory.Global

		outDevs.Devices = append(outDevs.Devices, device{
			Name:    *dev.Model,
			UUID:    dev.UUID,
			Temp:    *status.Temperature, // °C
			Powr:    *status.Power,
			MemTot:  *mem.Used + *mem.Free,
			MemUsed: *mem.Used,
			MemFree: *mem.Free,
		})
	}
	return outDevs, nil
}
