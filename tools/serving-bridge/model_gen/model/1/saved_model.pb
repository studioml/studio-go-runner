��
��
8
Const
output"dtype"
valuetensor"
dtypetype

NoOp
C
Placeholder
output"dtype"
dtypetype"
shapeshape:
@
ReadVariableOp
resource
value"dtype"
dtypetype�
�
StatefulPartitionedCall
args2Tin
output2Tout"
Tin
list(type)("
Tout
list(type)("	
ffunc"
configstring "
config_protostring "
executor_typestring �
q
VarHandleOp
resource"
	containerstring "
shared_namestring "
dtypetype"
shapeshape�"serve*2.1.02v2.1.0-rc2-17-ge5bf8de8��
|
Conv1/kernelVarHandleOp*
_output_shapes
: *
dtype0*
shape:*
shared_nameConv1/kernel
u
 Conv1/kernel/Read/ReadVariableOpReadVariableOpConv1/kernel*&
_output_shapes
:*
dtype0
l

Conv1/biasVarHandleOp*
_output_shapes
: *
dtype0*
shape:*
shared_name
Conv1/bias
e
Conv1/bias/Read/ReadVariableOpReadVariableOp
Conv1/bias*
_output_shapes
:*
dtype0
y
Softmax/kernelVarHandleOp*
_output_shapes
: *
dtype0*
shape:	�

*
shared_nameSoftmax/kernel
r
"Softmax/kernel/Read/ReadVariableOpReadVariableOpSoftmax/kernel*
_output_shapes
:	�

*
dtype0
p
Softmax/biasVarHandleOp*
_output_shapes
: *
dtype0*
shape:
*
shared_nameSoftmax/bias
i
 Softmax/bias/Read/ReadVariableOpReadVariableOpSoftmax/bias*
_output_shapes
:
*
dtype0
f
	Adam/iterVarHandleOp*
_output_shapes
: *
dtype0	*
shape: *
shared_name	Adam/iter
_
Adam/iter/Read/ReadVariableOpReadVariableOp	Adam/iter*
_output_shapes
: *
dtype0	
j
Adam/beta_1VarHandleOp*
_output_shapes
: *
dtype0*
shape: *
shared_nameAdam/beta_1
c
Adam/beta_1/Read/ReadVariableOpReadVariableOpAdam/beta_1*
_output_shapes
: *
dtype0
j
Adam/beta_2VarHandleOp*
_output_shapes
: *
dtype0*
shape: *
shared_nameAdam/beta_2
c
Adam/beta_2/Read/ReadVariableOpReadVariableOpAdam/beta_2*
_output_shapes
: *
dtype0
h

Adam/decayVarHandleOp*
_output_shapes
: *
dtype0*
shape: *
shared_name
Adam/decay
a
Adam/decay/Read/ReadVariableOpReadVariableOp
Adam/decay*
_output_shapes
: *
dtype0
x
Adam/learning_rateVarHandleOp*
_output_shapes
: *
dtype0*
shape: *#
shared_nameAdam/learning_rate
q
&Adam/learning_rate/Read/ReadVariableOpReadVariableOpAdam/learning_rate*
_output_shapes
: *
dtype0
^
totalVarHandleOp*
_output_shapes
: *
dtype0*
shape: *
shared_nametotal
W
total/Read/ReadVariableOpReadVariableOptotal*
_output_shapes
: *
dtype0
^
countVarHandleOp*
_output_shapes
: *
dtype0*
shape: *
shared_namecount
W
count/Read/ReadVariableOpReadVariableOpcount*
_output_shapes
: *
dtype0
�
Adam/Conv1/kernel/mVarHandleOp*
_output_shapes
: *
dtype0*
shape:*$
shared_nameAdam/Conv1/kernel/m
�
'Adam/Conv1/kernel/m/Read/ReadVariableOpReadVariableOpAdam/Conv1/kernel/m*&
_output_shapes
:*
dtype0
z
Adam/Conv1/bias/mVarHandleOp*
_output_shapes
: *
dtype0*
shape:*"
shared_nameAdam/Conv1/bias/m
s
%Adam/Conv1/bias/m/Read/ReadVariableOpReadVariableOpAdam/Conv1/bias/m*
_output_shapes
:*
dtype0
�
Adam/Softmax/kernel/mVarHandleOp*
_output_shapes
: *
dtype0*
shape:	�

*&
shared_nameAdam/Softmax/kernel/m
�
)Adam/Softmax/kernel/m/Read/ReadVariableOpReadVariableOpAdam/Softmax/kernel/m*
_output_shapes
:	�

*
dtype0
~
Adam/Softmax/bias/mVarHandleOp*
_output_shapes
: *
dtype0*
shape:
*$
shared_nameAdam/Softmax/bias/m
w
'Adam/Softmax/bias/m/Read/ReadVariableOpReadVariableOpAdam/Softmax/bias/m*
_output_shapes
:
*
dtype0
�
Adam/Conv1/kernel/vVarHandleOp*
_output_shapes
: *
dtype0*
shape:*$
shared_nameAdam/Conv1/kernel/v
�
'Adam/Conv1/kernel/v/Read/ReadVariableOpReadVariableOpAdam/Conv1/kernel/v*&
_output_shapes
:*
dtype0
z
Adam/Conv1/bias/vVarHandleOp*
_output_shapes
: *
dtype0*
shape:*"
shared_nameAdam/Conv1/bias/v
s
%Adam/Conv1/bias/v/Read/ReadVariableOpReadVariableOpAdam/Conv1/bias/v*
_output_shapes
:*
dtype0
�
Adam/Softmax/kernel/vVarHandleOp*
_output_shapes
: *
dtype0*
shape:	�

*&
shared_nameAdam/Softmax/kernel/v
�
)Adam/Softmax/kernel/v/Read/ReadVariableOpReadVariableOpAdam/Softmax/kernel/v*
_output_shapes
:	�

*
dtype0
~
Adam/Softmax/bias/vVarHandleOp*
_output_shapes
: *
dtype0*
shape:
*$
shared_nameAdam/Softmax/bias/v
w
'Adam/Softmax/bias/v/Read/ReadVariableOpReadVariableOpAdam/Softmax/bias/v*
_output_shapes
:
*
dtype0

NoOpNoOp
�
ConstConst"/device:CPU:0*
_output_shapes
: *
dtype0*�
value�B� B�
�
layer-0
layer_with_weights-0
layer-1
layer-2
layer_with_weights-1
layer-3
	optimizer
	variables
trainable_variables
regularization_losses
		keras_api


signatures
 
h

kernel
bias
regularization_losses
	variables
trainable_variables
	keras_api
R
regularization_losses
	variables
trainable_variables
	keras_api
h

kernel
bias
regularization_losses
	variables
trainable_variables
	keras_api
�
iter

beta_1

beta_2
	decay
learning_ratem<m=m>m?v@vAvBvC

0
1
2
3

0
1
2
3
 
�

 layers
!non_trainable_variables
	variables
trainable_variables
"layer_regularization_losses
#metrics
regularization_losses
 
XV
VARIABLE_VALUEConv1/kernel6layer_with_weights-0/kernel/.ATTRIBUTES/VARIABLE_VALUE
TR
VARIABLE_VALUE
Conv1/bias4layer_with_weights-0/bias/.ATTRIBUTES/VARIABLE_VALUE
 

0
1

0
1
�

$layers
%non_trainable_variables
regularization_losses
	variables
trainable_variables
&metrics
'layer_regularization_losses
 
 
 
�

(layers
)non_trainable_variables
regularization_losses
	variables
trainable_variables
*metrics
+layer_regularization_losses
ZX
VARIABLE_VALUESoftmax/kernel6layer_with_weights-1/kernel/.ATTRIBUTES/VARIABLE_VALUE
VT
VARIABLE_VALUESoftmax/bias4layer_with_weights-1/bias/.ATTRIBUTES/VARIABLE_VALUE
 

0
1

0
1
�

,layers
-non_trainable_variables
regularization_losses
	variables
trainable_variables
.metrics
/layer_regularization_losses
HF
VARIABLE_VALUE	Adam/iter)optimizer/iter/.ATTRIBUTES/VARIABLE_VALUE
LJ
VARIABLE_VALUEAdam/beta_1+optimizer/beta_1/.ATTRIBUTES/VARIABLE_VALUE
LJ
VARIABLE_VALUEAdam/beta_2+optimizer/beta_2/.ATTRIBUTES/VARIABLE_VALUE
JH
VARIABLE_VALUE
Adam/decay*optimizer/decay/.ATTRIBUTES/VARIABLE_VALUE
ZX
VARIABLE_VALUEAdam/learning_rate2optimizer/learning_rate/.ATTRIBUTES/VARIABLE_VALUE

0
1
2
 
 

00
 
 
 
 
 
 
 
 
 
 
 
 
x
	1total
	2count
3
_fn_kwargs
4regularization_losses
5	variables
6trainable_variables
7	keras_api
OM
VARIABLE_VALUEtotal4keras_api/metrics/0/total/.ATTRIBUTES/VARIABLE_VALUE
OM
VARIABLE_VALUEcount4keras_api/metrics/0/count/.ATTRIBUTES/VARIABLE_VALUE
 
 

10
21
 
�

8layers
9non_trainable_variables
4regularization_losses
5	variables
6trainable_variables
:metrics
;layer_regularization_losses
 

10
21
 
 
{y
VARIABLE_VALUEAdam/Conv1/kernel/mRlayer_with_weights-0/kernel/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUE
wu
VARIABLE_VALUEAdam/Conv1/bias/mPlayer_with_weights-0/bias/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUE
}{
VARIABLE_VALUEAdam/Softmax/kernel/mRlayer_with_weights-1/kernel/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUE
yw
VARIABLE_VALUEAdam/Softmax/bias/mPlayer_with_weights-1/bias/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUE
{y
VARIABLE_VALUEAdam/Conv1/kernel/vRlayer_with_weights-0/kernel/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUE
wu
VARIABLE_VALUEAdam/Conv1/bias/vPlayer_with_weights-0/bias/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUE
}{
VARIABLE_VALUEAdam/Softmax/kernel/vRlayer_with_weights-1/kernel/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUE
yw
VARIABLE_VALUEAdam/Softmax/bias/vPlayer_with_weights-1/bias/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUE
�
serving_default_Conv1_inputPlaceholder*/
_output_shapes
:���������*
dtype0*$
shape:���������
�
StatefulPartitionedCallStatefulPartitionedCallserving_default_Conv1_inputConv1/kernel
Conv1/biasSoftmax/kernelSoftmax/bias*
Tin	
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*,
f'R%
#__inference_signature_wrapper_29972
O
saver_filenamePlaceholder*
_output_shapes
: *
dtype0*
shape: 
�
StatefulPartitionedCall_1StatefulPartitionedCallsaver_filename Conv1/kernel/Read/ReadVariableOpConv1/bias/Read/ReadVariableOp"Softmax/kernel/Read/ReadVariableOp Softmax/bias/Read/ReadVariableOpAdam/iter/Read/ReadVariableOpAdam/beta_1/Read/ReadVariableOpAdam/beta_2/Read/ReadVariableOpAdam/decay/Read/ReadVariableOp&Adam/learning_rate/Read/ReadVariableOptotal/Read/ReadVariableOpcount/Read/ReadVariableOp'Adam/Conv1/kernel/m/Read/ReadVariableOp%Adam/Conv1/bias/m/Read/ReadVariableOp)Adam/Softmax/kernel/m/Read/ReadVariableOp'Adam/Softmax/bias/m/Read/ReadVariableOp'Adam/Conv1/kernel/v/Read/ReadVariableOp%Adam/Conv1/bias/v/Read/ReadVariableOp)Adam/Softmax/kernel/v/Read/ReadVariableOp'Adam/Softmax/bias/v/Read/ReadVariableOpConst* 
Tin
2	*
Tout
2*,
_gradient_op_typePartitionedCallUnused*
_output_shapes
: **
config_proto

CPU

GPU 2J 8*'
f"R 
__inference__traced_save_30140
�
StatefulPartitionedCall_2StatefulPartitionedCallsaver_filenameConv1/kernel
Conv1/biasSoftmax/kernelSoftmax/bias	Adam/iterAdam/beta_1Adam/beta_2
Adam/decayAdam/learning_ratetotalcountAdam/Conv1/kernel/mAdam/Conv1/bias/mAdam/Softmax/kernel/mAdam/Softmax/bias/mAdam/Conv1/kernel/vAdam/Conv1/bias/vAdam/Softmax/kernel/vAdam/Softmax/bias/v*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*
_output_shapes
: **
config_proto

CPU

GPU 2J 8**
f%R#
!__inference__traced_restore_30209��
�
�
E__inference_sequential_layer_call_and_return_conditional_losses_29947

inputs(
$conv1_statefulpartitionedcall_args_1(
$conv1_statefulpartitionedcall_args_2*
&softmax_statefulpartitionedcall_args_1*
&softmax_statefulpartitionedcall_args_2
identity��Conv1/StatefulPartitionedCall�Softmax/StatefulPartitionedCall�
Conv1/StatefulPartitionedCallStatefulPartitionedCallinputs$conv1_statefulpartitionedcall_args_1$conv1_statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*/
_output_shapes
:���������**
config_proto

CPU

GPU 2J 8*I
fDRB
@__inference_Conv1_layer_call_and_return_conditional_losses_298492
Conv1/StatefulPartitionedCall�
flatten/PartitionedCallPartitionedCall&Conv1/StatefulPartitionedCall:output:0*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*(
_output_shapes
:����������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_flatten_layer_call_and_return_conditional_losses_298702
flatten/PartitionedCall�
Softmax/StatefulPartitionedCallStatefulPartitionedCall flatten/PartitionedCall:output:0&softmax_statefulpartitionedcall_args_1&softmax_statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_Softmax_layer_call_and_return_conditional_losses_298892!
Softmax/StatefulPartitionedCall�
IdentityIdentity(Softmax/StatefulPartitionedCall:output:0^Conv1/StatefulPartitionedCall ^Softmax/StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::2>
Conv1/StatefulPartitionedCallConv1/StatefulPartitionedCall2B
Softmax/StatefulPartitionedCallSoftmax/StatefulPartitionedCall:& "
 
_user_specified_nameinputs
�/
�
__inference__traced_save_30140
file_prefix+
'savev2_conv1_kernel_read_readvariableop)
%savev2_conv1_bias_read_readvariableop-
)savev2_softmax_kernel_read_readvariableop+
'savev2_softmax_bias_read_readvariableop(
$savev2_adam_iter_read_readvariableop	*
&savev2_adam_beta_1_read_readvariableop*
&savev2_adam_beta_2_read_readvariableop)
%savev2_adam_decay_read_readvariableop1
-savev2_adam_learning_rate_read_readvariableop$
 savev2_total_read_readvariableop$
 savev2_count_read_readvariableop2
.savev2_adam_conv1_kernel_m_read_readvariableop0
,savev2_adam_conv1_bias_m_read_readvariableop4
0savev2_adam_softmax_kernel_m_read_readvariableop2
.savev2_adam_softmax_bias_m_read_readvariableop2
.savev2_adam_conv1_kernel_v_read_readvariableop0
,savev2_adam_conv1_bias_v_read_readvariableop4
0savev2_adam_softmax_kernel_v_read_readvariableop2
.savev2_adam_softmax_bias_v_read_readvariableop
savev2_1_const

identity_1��MergeV2Checkpoints�SaveV2�SaveV2_1�
StringJoin/inputs_1Const"/device:CPU:0*
_output_shapes
: *
dtype0*<
value3B1 B+_temp_c61e5cc353ae4524a7d35dc7e1dbcb0d/part2
StringJoin/inputs_1�

StringJoin
StringJoinfile_prefixStringJoin/inputs_1:output:0"/device:CPU:0*
N*
_output_shapes
: 2

StringJoinZ

num_shardsConst*
_output_shapes
: *
dtype0*
value	B :2

num_shards
ShardedFilename/shardConst"/device:CPU:0*
_output_shapes
: *
dtype0*
value	B : 2
ShardedFilename/shard�
ShardedFilenameShardedFilenameStringJoin:output:0ShardedFilename/shard:output:0num_shards:output:0"/device:CPU:0*
_output_shapes
: 2
ShardedFilename�

SaveV2/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*�	
value�	B�	B6layer_with_weights-0/kernel/.ATTRIBUTES/VARIABLE_VALUEB4layer_with_weights-0/bias/.ATTRIBUTES/VARIABLE_VALUEB6layer_with_weights-1/kernel/.ATTRIBUTES/VARIABLE_VALUEB4layer_with_weights-1/bias/.ATTRIBUTES/VARIABLE_VALUEB)optimizer/iter/.ATTRIBUTES/VARIABLE_VALUEB+optimizer/beta_1/.ATTRIBUTES/VARIABLE_VALUEB+optimizer/beta_2/.ATTRIBUTES/VARIABLE_VALUEB*optimizer/decay/.ATTRIBUTES/VARIABLE_VALUEB2optimizer/learning_rate/.ATTRIBUTES/VARIABLE_VALUEB4keras_api/metrics/0/total/.ATTRIBUTES/VARIABLE_VALUEB4keras_api/metrics/0/count/.ATTRIBUTES/VARIABLE_VALUEBRlayer_with_weights-0/kernel/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUEBPlayer_with_weights-0/bias/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUEBRlayer_with_weights-1/kernel/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUEBPlayer_with_weights-1/bias/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUEBRlayer_with_weights-0/kernel/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUEBPlayer_with_weights-0/bias/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUEBRlayer_with_weights-1/kernel/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUEBPlayer_with_weights-1/bias/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUE2
SaveV2/tensor_names�
SaveV2/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*9
value0B.B B B B B B B B B B B B B B B B B B B 2
SaveV2/shape_and_slices�
SaveV2SaveV2ShardedFilename:filename:0SaveV2/tensor_names:output:0 SaveV2/shape_and_slices:output:0'savev2_conv1_kernel_read_readvariableop%savev2_conv1_bias_read_readvariableop)savev2_softmax_kernel_read_readvariableop'savev2_softmax_bias_read_readvariableop$savev2_adam_iter_read_readvariableop&savev2_adam_beta_1_read_readvariableop&savev2_adam_beta_2_read_readvariableop%savev2_adam_decay_read_readvariableop-savev2_adam_learning_rate_read_readvariableop savev2_total_read_readvariableop savev2_count_read_readvariableop.savev2_adam_conv1_kernel_m_read_readvariableop,savev2_adam_conv1_bias_m_read_readvariableop0savev2_adam_softmax_kernel_m_read_readvariableop.savev2_adam_softmax_bias_m_read_readvariableop.savev2_adam_conv1_kernel_v_read_readvariableop,savev2_adam_conv1_bias_v_read_readvariableop0savev2_adam_softmax_kernel_v_read_readvariableop.savev2_adam_softmax_bias_v_read_readvariableop"/device:CPU:0*
_output_shapes
 *!
dtypes
2	2
SaveV2�
ShardedFilename_1/shardConst"/device:CPU:0*
_output_shapes
: *
dtype0*
value	B :2
ShardedFilename_1/shard�
ShardedFilename_1ShardedFilenameStringJoin:output:0 ShardedFilename_1/shard:output:0num_shards:output:0"/device:CPU:0*
_output_shapes
: 2
ShardedFilename_1�
SaveV2_1/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*1
value(B&B_CHECKPOINTABLE_OBJECT_GRAPH2
SaveV2_1/tensor_names�
SaveV2_1/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*
valueB
B 2
SaveV2_1/shape_and_slices�
SaveV2_1SaveV2ShardedFilename_1:filename:0SaveV2_1/tensor_names:output:0"SaveV2_1/shape_and_slices:output:0savev2_1_const^SaveV2"/device:CPU:0*
_output_shapes
 *
dtypes
22

SaveV2_1�
&MergeV2Checkpoints/checkpoint_prefixesPackShardedFilename:filename:0ShardedFilename_1:filename:0^SaveV2	^SaveV2_1"/device:CPU:0*
N*
T0*
_output_shapes
:2(
&MergeV2Checkpoints/checkpoint_prefixes�
MergeV2CheckpointsMergeV2Checkpoints/MergeV2Checkpoints/checkpoint_prefixes:output:0file_prefix	^SaveV2_1"/device:CPU:0*
_output_shapes
 2
MergeV2Checkpointsr
IdentityIdentityfile_prefix^MergeV2Checkpoints"/device:CPU:0*
T0*
_output_shapes
: 2

Identity�

Identity_1IdentityIdentity:output:0^MergeV2Checkpoints^SaveV2	^SaveV2_1*
T0*
_output_shapes
: 2

Identity_1"!

identity_1Identity_1:output:0*�
_input_shapes�
�: :::	�

:
: : : : : : : :::	�

:
:::	�

:
: 2(
MergeV2CheckpointsMergeV2Checkpoints2
SaveV2SaveV22
SaveV2_1SaveV2_1:+ '
%
_user_specified_namefile_prefix
�
�
 __inference__wrapped_model_29836
conv1_input3
/sequential_conv1_conv2d_readvariableop_resource4
0sequential_conv1_biasadd_readvariableop_resource5
1sequential_softmax_matmul_readvariableop_resource6
2sequential_softmax_biasadd_readvariableop_resource
identity��'sequential/Conv1/BiasAdd/ReadVariableOp�&sequential/Conv1/Conv2D/ReadVariableOp�)sequential/Softmax/BiasAdd/ReadVariableOp�(sequential/Softmax/MatMul/ReadVariableOp�
&sequential/Conv1/Conv2D/ReadVariableOpReadVariableOp/sequential_conv1_conv2d_readvariableop_resource*&
_output_shapes
:*
dtype02(
&sequential/Conv1/Conv2D/ReadVariableOp�
sequential/Conv1/Conv2DConv2Dconv1_input.sequential/Conv1/Conv2D/ReadVariableOp:value:0*
T0*/
_output_shapes
:���������*
paddingVALID*
strides
2
sequential/Conv1/Conv2D�
'sequential/Conv1/BiasAdd/ReadVariableOpReadVariableOp0sequential_conv1_biasadd_readvariableop_resource*
_output_shapes
:*
dtype02)
'sequential/Conv1/BiasAdd/ReadVariableOp�
sequential/Conv1/BiasAddBiasAdd sequential/Conv1/Conv2D:output:0/sequential/Conv1/BiasAdd/ReadVariableOp:value:0*
T0*/
_output_shapes
:���������2
sequential/Conv1/BiasAdd�
sequential/Conv1/ReluRelu!sequential/Conv1/BiasAdd:output:0*
T0*/
_output_shapes
:���������2
sequential/Conv1/Relu�
sequential/flatten/ConstConst*
_output_shapes
:*
dtype0*
valueB"����H  2
sequential/flatten/Const�
sequential/flatten/ReshapeReshape#sequential/Conv1/Relu:activations:0!sequential/flatten/Const:output:0*
T0*(
_output_shapes
:����������
2
sequential/flatten/Reshape�
(sequential/Softmax/MatMul/ReadVariableOpReadVariableOp1sequential_softmax_matmul_readvariableop_resource*
_output_shapes
:	�

*
dtype02*
(sequential/Softmax/MatMul/ReadVariableOp�
sequential/Softmax/MatMulMatMul#sequential/flatten/Reshape:output:00sequential/Softmax/MatMul/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2
sequential/Softmax/MatMul�
)sequential/Softmax/BiasAdd/ReadVariableOpReadVariableOp2sequential_softmax_biasadd_readvariableop_resource*
_output_shapes
:
*
dtype02+
)sequential/Softmax/BiasAdd/ReadVariableOp�
sequential/Softmax/BiasAddBiasAdd#sequential/Softmax/MatMul:product:01sequential/Softmax/BiasAdd/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2
sequential/Softmax/BiasAdd�
sequential/Softmax/SoftmaxSoftmax#sequential/Softmax/BiasAdd:output:0*
T0*'
_output_shapes
:���������
2
sequential/Softmax/Softmax�
IdentityIdentity$sequential/Softmax/Softmax:softmax:0(^sequential/Conv1/BiasAdd/ReadVariableOp'^sequential/Conv1/Conv2D/ReadVariableOp*^sequential/Softmax/BiasAdd/ReadVariableOp)^sequential/Softmax/MatMul/ReadVariableOp*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::2R
'sequential/Conv1/BiasAdd/ReadVariableOp'sequential/Conv1/BiasAdd/ReadVariableOp2P
&sequential/Conv1/Conv2D/ReadVariableOp&sequential/Conv1/Conv2D/ReadVariableOp2V
)sequential/Softmax/BiasAdd/ReadVariableOp)sequential/Softmax/BiasAdd/ReadVariableOp2T
(sequential/Softmax/MatMul/ReadVariableOp(sequential/Softmax/MatMul/ReadVariableOp:+ '
%
_user_specified_nameConv1_input
�	
�
B__inference_Softmax_layer_call_and_return_conditional_losses_29889

inputs"
matmul_readvariableop_resource#
biasadd_readvariableop_resource
identity��BiasAdd/ReadVariableOp�MatMul/ReadVariableOp�
MatMul/ReadVariableOpReadVariableOpmatmul_readvariableop_resource*
_output_shapes
:	�

*
dtype02
MatMul/ReadVariableOps
MatMulMatMulinputsMatMul/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2
MatMul�
BiasAdd/ReadVariableOpReadVariableOpbiasadd_readvariableop_resource*
_output_shapes
:
*
dtype02
BiasAdd/ReadVariableOp�
BiasAddBiasAddMatMul:product:0BiasAdd/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2	
BiasAdda
SoftmaxSoftmaxBiasAdd:output:0*
T0*'
_output_shapes
:���������
2	
Softmax�
IdentityIdentitySoftmax:softmax:0^BiasAdd/ReadVariableOp^MatMul/ReadVariableOp*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*/
_input_shapes
:����������
::20
BiasAdd/ReadVariableOpBiasAdd/ReadVariableOp2.
MatMul/ReadVariableOpMatMul/ReadVariableOp:& "
 
_user_specified_nameinputs
�
�
#__inference_signature_wrapper_29972
conv1_input"
statefulpartitionedcall_args_1"
statefulpartitionedcall_args_2"
statefulpartitionedcall_args_3"
statefulpartitionedcall_args_4
identity��StatefulPartitionedCall�
StatefulPartitionedCallStatefulPartitionedCallconv1_inputstatefulpartitionedcall_args_1statefulpartitionedcall_args_2statefulpartitionedcall_args_3statefulpartitionedcall_args_4*
Tin	
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*)
f$R"
 __inference__wrapped_model_298362
StatefulPartitionedCall�
IdentityIdentity StatefulPartitionedCall:output:0^StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::22
StatefulPartitionedCallStatefulPartitionedCall:+ '
%
_user_specified_nameConv1_input
�
�
'__inference_Softmax_layer_call_fn_30059

inputs"
statefulpartitionedcall_args_1"
statefulpartitionedcall_args_2
identity��StatefulPartitionedCall�
StatefulPartitionedCallStatefulPartitionedCallinputsstatefulpartitionedcall_args_1statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_Softmax_layer_call_and_return_conditional_losses_298892
StatefulPartitionedCall�
IdentityIdentity StatefulPartitionedCall:output:0^StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*/
_input_shapes
:����������
::22
StatefulPartitionedCallStatefulPartitionedCall:& "
 
_user_specified_nameinputs
�
�
E__inference_sequential_layer_call_and_return_conditional_losses_29902
conv1_input(
$conv1_statefulpartitionedcall_args_1(
$conv1_statefulpartitionedcall_args_2*
&softmax_statefulpartitionedcall_args_1*
&softmax_statefulpartitionedcall_args_2
identity��Conv1/StatefulPartitionedCall�Softmax/StatefulPartitionedCall�
Conv1/StatefulPartitionedCallStatefulPartitionedCallconv1_input$conv1_statefulpartitionedcall_args_1$conv1_statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*/
_output_shapes
:���������**
config_proto

CPU

GPU 2J 8*I
fDRB
@__inference_Conv1_layer_call_and_return_conditional_losses_298492
Conv1/StatefulPartitionedCall�
flatten/PartitionedCallPartitionedCall&Conv1/StatefulPartitionedCall:output:0*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*(
_output_shapes
:����������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_flatten_layer_call_and_return_conditional_losses_298702
flatten/PartitionedCall�
Softmax/StatefulPartitionedCallStatefulPartitionedCall flatten/PartitionedCall:output:0&softmax_statefulpartitionedcall_args_1&softmax_statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_Softmax_layer_call_and_return_conditional_losses_298892!
Softmax/StatefulPartitionedCall�
IdentityIdentity(Softmax/StatefulPartitionedCall:output:0^Conv1/StatefulPartitionedCall ^Softmax/StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::2>
Conv1/StatefulPartitionedCallConv1/StatefulPartitionedCall2B
Softmax/StatefulPartitionedCallSoftmax/StatefulPartitionedCall:+ '
%
_user_specified_nameConv1_input
�
�
E__inference_sequential_layer_call_and_return_conditional_losses_30012

inputs(
$conv1_conv2d_readvariableop_resource)
%conv1_biasadd_readvariableop_resource*
&softmax_matmul_readvariableop_resource+
'softmax_biasadd_readvariableop_resource
identity��Conv1/BiasAdd/ReadVariableOp�Conv1/Conv2D/ReadVariableOp�Softmax/BiasAdd/ReadVariableOp�Softmax/MatMul/ReadVariableOp�
Conv1/Conv2D/ReadVariableOpReadVariableOp$conv1_conv2d_readvariableop_resource*&
_output_shapes
:*
dtype02
Conv1/Conv2D/ReadVariableOp�
Conv1/Conv2DConv2Dinputs#Conv1/Conv2D/ReadVariableOp:value:0*
T0*/
_output_shapes
:���������*
paddingVALID*
strides
2
Conv1/Conv2D�
Conv1/BiasAdd/ReadVariableOpReadVariableOp%conv1_biasadd_readvariableop_resource*
_output_shapes
:*
dtype02
Conv1/BiasAdd/ReadVariableOp�
Conv1/BiasAddBiasAddConv1/Conv2D:output:0$Conv1/BiasAdd/ReadVariableOp:value:0*
T0*/
_output_shapes
:���������2
Conv1/BiasAddr

Conv1/ReluReluConv1/BiasAdd:output:0*
T0*/
_output_shapes
:���������2

Conv1/Reluo
flatten/ConstConst*
_output_shapes
:*
dtype0*
valueB"����H  2
flatten/Const�
flatten/ReshapeReshapeConv1/Relu:activations:0flatten/Const:output:0*
T0*(
_output_shapes
:����������
2
flatten/Reshape�
Softmax/MatMul/ReadVariableOpReadVariableOp&softmax_matmul_readvariableop_resource*
_output_shapes
:	�

*
dtype02
Softmax/MatMul/ReadVariableOp�
Softmax/MatMulMatMulflatten/Reshape:output:0%Softmax/MatMul/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2
Softmax/MatMul�
Softmax/BiasAdd/ReadVariableOpReadVariableOp'softmax_biasadd_readvariableop_resource*
_output_shapes
:
*
dtype02 
Softmax/BiasAdd/ReadVariableOp�
Softmax/BiasAddBiasAddSoftmax/MatMul:product:0&Softmax/BiasAdd/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2
Softmax/BiasAddy
Softmax/SoftmaxSoftmaxSoftmax/BiasAdd:output:0*
T0*'
_output_shapes
:���������
2
Softmax/Softmax�
IdentityIdentitySoftmax/Softmax:softmax:0^Conv1/BiasAdd/ReadVariableOp^Conv1/Conv2D/ReadVariableOp^Softmax/BiasAdd/ReadVariableOp^Softmax/MatMul/ReadVariableOp*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::2<
Conv1/BiasAdd/ReadVariableOpConv1/BiasAdd/ReadVariableOp2:
Conv1/Conv2D/ReadVariableOpConv1/Conv2D/ReadVariableOp2@
Softmax/BiasAdd/ReadVariableOpSoftmax/BiasAdd/ReadVariableOp2>
Softmax/MatMul/ReadVariableOpSoftmax/MatMul/ReadVariableOp:& "
 
_user_specified_nameinputs
�
�
E__inference_sequential_layer_call_and_return_conditional_losses_29927

inputs(
$conv1_statefulpartitionedcall_args_1(
$conv1_statefulpartitionedcall_args_2*
&softmax_statefulpartitionedcall_args_1*
&softmax_statefulpartitionedcall_args_2
identity��Conv1/StatefulPartitionedCall�Softmax/StatefulPartitionedCall�
Conv1/StatefulPartitionedCallStatefulPartitionedCallinputs$conv1_statefulpartitionedcall_args_1$conv1_statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*/
_output_shapes
:���������**
config_proto

CPU

GPU 2J 8*I
fDRB
@__inference_Conv1_layer_call_and_return_conditional_losses_298492
Conv1/StatefulPartitionedCall�
flatten/PartitionedCallPartitionedCall&Conv1/StatefulPartitionedCall:output:0*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*(
_output_shapes
:����������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_flatten_layer_call_and_return_conditional_losses_298702
flatten/PartitionedCall�
Softmax/StatefulPartitionedCallStatefulPartitionedCall flatten/PartitionedCall:output:0&softmax_statefulpartitionedcall_args_1&softmax_statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_Softmax_layer_call_and_return_conditional_losses_298892!
Softmax/StatefulPartitionedCall�
IdentityIdentity(Softmax/StatefulPartitionedCall:output:0^Conv1/StatefulPartitionedCall ^Softmax/StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::2>
Conv1/StatefulPartitionedCallConv1/StatefulPartitionedCall2B
Softmax/StatefulPartitionedCallSoftmax/StatefulPartitionedCall:& "
 
_user_specified_nameinputs
�
C
'__inference_flatten_layer_call_fn_30041

inputs
identity�
PartitionedCallPartitionedCallinputs*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*(
_output_shapes
:����������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_flatten_layer_call_and_return_conditional_losses_298702
PartitionedCallm
IdentityIdentityPartitionedCall:output:0*
T0*(
_output_shapes
:����������
2

Identity"
identityIdentity:output:0*.
_input_shapes
:���������:& "
 
_user_specified_nameinputs
�
�
*__inference_sequential_layer_call_fn_29954
conv1_input"
statefulpartitionedcall_args_1"
statefulpartitionedcall_args_2"
statefulpartitionedcall_args_3"
statefulpartitionedcall_args_4
identity��StatefulPartitionedCall�
StatefulPartitionedCallStatefulPartitionedCallconv1_inputstatefulpartitionedcall_args_1statefulpartitionedcall_args_2statefulpartitionedcall_args_3statefulpartitionedcall_args_4*
Tin	
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*N
fIRG
E__inference_sequential_layer_call_and_return_conditional_losses_299472
StatefulPartitionedCall�
IdentityIdentity StatefulPartitionedCall:output:0^StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::22
StatefulPartitionedCallStatefulPartitionedCall:+ '
%
_user_specified_nameConv1_input
�
�
E__inference_sequential_layer_call_and_return_conditional_losses_29913
conv1_input(
$conv1_statefulpartitionedcall_args_1(
$conv1_statefulpartitionedcall_args_2*
&softmax_statefulpartitionedcall_args_1*
&softmax_statefulpartitionedcall_args_2
identity��Conv1/StatefulPartitionedCall�Softmax/StatefulPartitionedCall�
Conv1/StatefulPartitionedCallStatefulPartitionedCallconv1_input$conv1_statefulpartitionedcall_args_1$conv1_statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*/
_output_shapes
:���������**
config_proto

CPU

GPU 2J 8*I
fDRB
@__inference_Conv1_layer_call_and_return_conditional_losses_298492
Conv1/StatefulPartitionedCall�
flatten/PartitionedCallPartitionedCall&Conv1/StatefulPartitionedCall:output:0*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*(
_output_shapes
:����������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_flatten_layer_call_and_return_conditional_losses_298702
flatten/PartitionedCall�
Softmax/StatefulPartitionedCallStatefulPartitionedCall flatten/PartitionedCall:output:0&softmax_statefulpartitionedcall_args_1&softmax_statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*K
fFRD
B__inference_Softmax_layer_call_and_return_conditional_losses_298892!
Softmax/StatefulPartitionedCall�
IdentityIdentity(Softmax/StatefulPartitionedCall:output:0^Conv1/StatefulPartitionedCall ^Softmax/StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::2>
Conv1/StatefulPartitionedCallConv1/StatefulPartitionedCall2B
Softmax/StatefulPartitionedCallSoftmax/StatefulPartitionedCall:+ '
%
_user_specified_nameConv1_input
�
�
@__inference_Conv1_layer_call_and_return_conditional_losses_29849

inputs"
conv2d_readvariableop_resource#
biasadd_readvariableop_resource
identity��BiasAdd/ReadVariableOp�Conv2D/ReadVariableOpo
dilation_rateConst*
_output_shapes
:*
dtype0*
valueB"      2
dilation_rate�
Conv2D/ReadVariableOpReadVariableOpconv2d_readvariableop_resource*&
_output_shapes
:*
dtype02
Conv2D/ReadVariableOp�
Conv2DConv2DinputsConv2D/ReadVariableOp:value:0*
T0*A
_output_shapes/
-:+���������������������������*
paddingVALID*
strides
2
Conv2D�
BiasAdd/ReadVariableOpReadVariableOpbiasadd_readvariableop_resource*
_output_shapes
:*
dtype02
BiasAdd/ReadVariableOp�
BiasAddBiasAddConv2D:output:0BiasAdd/ReadVariableOp:value:0*
T0*A
_output_shapes/
-:+���������������������������2	
BiasAddr
ReluReluBiasAdd:output:0*
T0*A
_output_shapes/
-:+���������������������������2
Relu�
IdentityIdentityRelu:activations:0^BiasAdd/ReadVariableOp^Conv2D/ReadVariableOp*
T0*A
_output_shapes/
-:+���������������������������2

Identity"
identityIdentity:output:0*H
_input_shapes7
5:+���������������������������::20
BiasAdd/ReadVariableOpBiasAdd/ReadVariableOp2.
Conv2D/ReadVariableOpConv2D/ReadVariableOp:& "
 
_user_specified_nameinputs
�
^
B__inference_flatten_layer_call_and_return_conditional_losses_30036

inputs
identity_
ConstConst*
_output_shapes
:*
dtype0*
valueB"����H  2
Consth
ReshapeReshapeinputsConst:output:0*
T0*(
_output_shapes
:����������
2	
Reshapee
IdentityIdentityReshape:output:0*
T0*(
_output_shapes
:����������
2

Identity"
identityIdentity:output:0*.
_input_shapes
:���������:& "
 
_user_specified_nameinputs
�
�
E__inference_sequential_layer_call_and_return_conditional_losses_29992

inputs(
$conv1_conv2d_readvariableop_resource)
%conv1_biasadd_readvariableop_resource*
&softmax_matmul_readvariableop_resource+
'softmax_biasadd_readvariableop_resource
identity��Conv1/BiasAdd/ReadVariableOp�Conv1/Conv2D/ReadVariableOp�Softmax/BiasAdd/ReadVariableOp�Softmax/MatMul/ReadVariableOp�
Conv1/Conv2D/ReadVariableOpReadVariableOp$conv1_conv2d_readvariableop_resource*&
_output_shapes
:*
dtype02
Conv1/Conv2D/ReadVariableOp�
Conv1/Conv2DConv2Dinputs#Conv1/Conv2D/ReadVariableOp:value:0*
T0*/
_output_shapes
:���������*
paddingVALID*
strides
2
Conv1/Conv2D�
Conv1/BiasAdd/ReadVariableOpReadVariableOp%conv1_biasadd_readvariableop_resource*
_output_shapes
:*
dtype02
Conv1/BiasAdd/ReadVariableOp�
Conv1/BiasAddBiasAddConv1/Conv2D:output:0$Conv1/BiasAdd/ReadVariableOp:value:0*
T0*/
_output_shapes
:���������2
Conv1/BiasAddr

Conv1/ReluReluConv1/BiasAdd:output:0*
T0*/
_output_shapes
:���������2

Conv1/Reluo
flatten/ConstConst*
_output_shapes
:*
dtype0*
valueB"����H  2
flatten/Const�
flatten/ReshapeReshapeConv1/Relu:activations:0flatten/Const:output:0*
T0*(
_output_shapes
:����������
2
flatten/Reshape�
Softmax/MatMul/ReadVariableOpReadVariableOp&softmax_matmul_readvariableop_resource*
_output_shapes
:	�

*
dtype02
Softmax/MatMul/ReadVariableOp�
Softmax/MatMulMatMulflatten/Reshape:output:0%Softmax/MatMul/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2
Softmax/MatMul�
Softmax/BiasAdd/ReadVariableOpReadVariableOp'softmax_biasadd_readvariableop_resource*
_output_shapes
:
*
dtype02 
Softmax/BiasAdd/ReadVariableOp�
Softmax/BiasAddBiasAddSoftmax/MatMul:product:0&Softmax/BiasAdd/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2
Softmax/BiasAddy
Softmax/SoftmaxSoftmaxSoftmax/BiasAdd:output:0*
T0*'
_output_shapes
:���������
2
Softmax/Softmax�
IdentityIdentitySoftmax/Softmax:softmax:0^Conv1/BiasAdd/ReadVariableOp^Conv1/Conv2D/ReadVariableOp^Softmax/BiasAdd/ReadVariableOp^Softmax/MatMul/ReadVariableOp*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::2<
Conv1/BiasAdd/ReadVariableOpConv1/BiasAdd/ReadVariableOp2:
Conv1/Conv2D/ReadVariableOpConv1/Conv2D/ReadVariableOp2@
Softmax/BiasAdd/ReadVariableOpSoftmax/BiasAdd/ReadVariableOp2>
Softmax/MatMul/ReadVariableOpSoftmax/MatMul/ReadVariableOp:& "
 
_user_specified_nameinputs
�
�
*__inference_sequential_layer_call_fn_30021

inputs"
statefulpartitionedcall_args_1"
statefulpartitionedcall_args_2"
statefulpartitionedcall_args_3"
statefulpartitionedcall_args_4
identity��StatefulPartitionedCall�
StatefulPartitionedCallStatefulPartitionedCallinputsstatefulpartitionedcall_args_1statefulpartitionedcall_args_2statefulpartitionedcall_args_3statefulpartitionedcall_args_4*
Tin	
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*N
fIRG
E__inference_sequential_layer_call_and_return_conditional_losses_299272
StatefulPartitionedCall�
IdentityIdentity StatefulPartitionedCall:output:0^StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::22
StatefulPartitionedCallStatefulPartitionedCall:& "
 
_user_specified_nameinputs
�	
�
B__inference_Softmax_layer_call_and_return_conditional_losses_30052

inputs"
matmul_readvariableop_resource#
biasadd_readvariableop_resource
identity��BiasAdd/ReadVariableOp�MatMul/ReadVariableOp�
MatMul/ReadVariableOpReadVariableOpmatmul_readvariableop_resource*
_output_shapes
:	�

*
dtype02
MatMul/ReadVariableOps
MatMulMatMulinputsMatMul/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2
MatMul�
BiasAdd/ReadVariableOpReadVariableOpbiasadd_readvariableop_resource*
_output_shapes
:
*
dtype02
BiasAdd/ReadVariableOp�
BiasAddBiasAddMatMul:product:0BiasAdd/ReadVariableOp:value:0*
T0*'
_output_shapes
:���������
2	
BiasAdda
SoftmaxSoftmaxBiasAdd:output:0*
T0*'
_output_shapes
:���������
2	
Softmax�
IdentityIdentitySoftmax:softmax:0^BiasAdd/ReadVariableOp^MatMul/ReadVariableOp*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*/
_input_shapes
:����������
::20
BiasAdd/ReadVariableOpBiasAdd/ReadVariableOp2.
MatMul/ReadVariableOpMatMul/ReadVariableOp:& "
 
_user_specified_nameinputs
�
�
*__inference_sequential_layer_call_fn_30030

inputs"
statefulpartitionedcall_args_1"
statefulpartitionedcall_args_2"
statefulpartitionedcall_args_3"
statefulpartitionedcall_args_4
identity��StatefulPartitionedCall�
StatefulPartitionedCallStatefulPartitionedCallinputsstatefulpartitionedcall_args_1statefulpartitionedcall_args_2statefulpartitionedcall_args_3statefulpartitionedcall_args_4*
Tin	
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*N
fIRG
E__inference_sequential_layer_call_and_return_conditional_losses_299472
StatefulPartitionedCall�
IdentityIdentity StatefulPartitionedCall:output:0^StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::22
StatefulPartitionedCallStatefulPartitionedCall:& "
 
_user_specified_nameinputs
�
�
*__inference_sequential_layer_call_fn_29934
conv1_input"
statefulpartitionedcall_args_1"
statefulpartitionedcall_args_2"
statefulpartitionedcall_args_3"
statefulpartitionedcall_args_4
identity��StatefulPartitionedCall�
StatefulPartitionedCallStatefulPartitionedCallconv1_inputstatefulpartitionedcall_args_1statefulpartitionedcall_args_2statefulpartitionedcall_args_3statefulpartitionedcall_args_4*
Tin	
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*'
_output_shapes
:���������
**
config_proto

CPU

GPU 2J 8*N
fIRG
E__inference_sequential_layer_call_and_return_conditional_losses_299272
StatefulPartitionedCall�
IdentityIdentity StatefulPartitionedCall:output:0^StatefulPartitionedCall*
T0*'
_output_shapes
:���������
2

Identity"
identityIdentity:output:0*>
_input_shapes-
+:���������::::22
StatefulPartitionedCallStatefulPartitionedCall:+ '
%
_user_specified_nameConv1_input
�
�
%__inference_Conv1_layer_call_fn_29857

inputs"
statefulpartitionedcall_args_1"
statefulpartitionedcall_args_2
identity��StatefulPartitionedCall�
StatefulPartitionedCallStatefulPartitionedCallinputsstatefulpartitionedcall_args_1statefulpartitionedcall_args_2*
Tin
2*
Tout
2*,
_gradient_op_typePartitionedCallUnused*A
_output_shapes/
-:+���������������������������**
config_proto

CPU

GPU 2J 8*I
fDRB
@__inference_Conv1_layer_call_and_return_conditional_losses_298492
StatefulPartitionedCall�
IdentityIdentity StatefulPartitionedCall:output:0^StatefulPartitionedCall*
T0*A
_output_shapes/
-:+���������������������������2

Identity"
identityIdentity:output:0*H
_input_shapes7
5:+���������������������������::22
StatefulPartitionedCallStatefulPartitionedCall:& "
 
_user_specified_nameinputs
�
^
B__inference_flatten_layer_call_and_return_conditional_losses_29870

inputs
identity_
ConstConst*
_output_shapes
:*
dtype0*
valueB"����H  2
Consth
ReshapeReshapeinputsConst:output:0*
T0*(
_output_shapes
:����������
2	
Reshapee
IdentityIdentityReshape:output:0*
T0*(
_output_shapes
:����������
2

Identity"
identityIdentity:output:0*.
_input_shapes
:���������:& "
 
_user_specified_nameinputs
�R
�	
!__inference__traced_restore_30209
file_prefix!
assignvariableop_conv1_kernel!
assignvariableop_1_conv1_bias%
!assignvariableop_2_softmax_kernel#
assignvariableop_3_softmax_bias 
assignvariableop_4_adam_iter"
assignvariableop_5_adam_beta_1"
assignvariableop_6_adam_beta_2!
assignvariableop_7_adam_decay)
%assignvariableop_8_adam_learning_rate
assignvariableop_9_total
assignvariableop_10_count+
'assignvariableop_11_adam_conv1_kernel_m)
%assignvariableop_12_adam_conv1_bias_m-
)assignvariableop_13_adam_softmax_kernel_m+
'assignvariableop_14_adam_softmax_bias_m+
'assignvariableop_15_adam_conv1_kernel_v)
%assignvariableop_16_adam_conv1_bias_v-
)assignvariableop_17_adam_softmax_kernel_v+
'assignvariableop_18_adam_softmax_bias_v
identity_20��AssignVariableOp�AssignVariableOp_1�AssignVariableOp_10�AssignVariableOp_11�AssignVariableOp_12�AssignVariableOp_13�AssignVariableOp_14�AssignVariableOp_15�AssignVariableOp_16�AssignVariableOp_17�AssignVariableOp_18�AssignVariableOp_2�AssignVariableOp_3�AssignVariableOp_4�AssignVariableOp_5�AssignVariableOp_6�AssignVariableOp_7�AssignVariableOp_8�AssignVariableOp_9�	RestoreV2�RestoreV2_1�

RestoreV2/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*�	
value�	B�	B6layer_with_weights-0/kernel/.ATTRIBUTES/VARIABLE_VALUEB4layer_with_weights-0/bias/.ATTRIBUTES/VARIABLE_VALUEB6layer_with_weights-1/kernel/.ATTRIBUTES/VARIABLE_VALUEB4layer_with_weights-1/bias/.ATTRIBUTES/VARIABLE_VALUEB)optimizer/iter/.ATTRIBUTES/VARIABLE_VALUEB+optimizer/beta_1/.ATTRIBUTES/VARIABLE_VALUEB+optimizer/beta_2/.ATTRIBUTES/VARIABLE_VALUEB*optimizer/decay/.ATTRIBUTES/VARIABLE_VALUEB2optimizer/learning_rate/.ATTRIBUTES/VARIABLE_VALUEB4keras_api/metrics/0/total/.ATTRIBUTES/VARIABLE_VALUEB4keras_api/metrics/0/count/.ATTRIBUTES/VARIABLE_VALUEBRlayer_with_weights-0/kernel/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUEBPlayer_with_weights-0/bias/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUEBRlayer_with_weights-1/kernel/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUEBPlayer_with_weights-1/bias/.OPTIMIZER_SLOT/optimizer/m/.ATTRIBUTES/VARIABLE_VALUEBRlayer_with_weights-0/kernel/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUEBPlayer_with_weights-0/bias/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUEBRlayer_with_weights-1/kernel/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUEBPlayer_with_weights-1/bias/.OPTIMIZER_SLOT/optimizer/v/.ATTRIBUTES/VARIABLE_VALUE2
RestoreV2/tensor_names�
RestoreV2/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*9
value0B.B B B B B B B B B B B B B B B B B B B 2
RestoreV2/shape_and_slices�
	RestoreV2	RestoreV2file_prefixRestoreV2/tensor_names:output:0#RestoreV2/shape_and_slices:output:0"/device:CPU:0*`
_output_shapesN
L:::::::::::::::::::*!
dtypes
2	2
	RestoreV2X
IdentityIdentityRestoreV2:tensors:0*
T0*
_output_shapes
:2

Identity�
AssignVariableOpAssignVariableOpassignvariableop_conv1_kernelIdentity:output:0*
_output_shapes
 *
dtype02
AssignVariableOp\

Identity_1IdentityRestoreV2:tensors:1*
T0*
_output_shapes
:2

Identity_1�
AssignVariableOp_1AssignVariableOpassignvariableop_1_conv1_biasIdentity_1:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_1\

Identity_2IdentityRestoreV2:tensors:2*
T0*
_output_shapes
:2

Identity_2�
AssignVariableOp_2AssignVariableOp!assignvariableop_2_softmax_kernelIdentity_2:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_2\

Identity_3IdentityRestoreV2:tensors:3*
T0*
_output_shapes
:2

Identity_3�
AssignVariableOp_3AssignVariableOpassignvariableop_3_softmax_biasIdentity_3:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_3\

Identity_4IdentityRestoreV2:tensors:4*
T0	*
_output_shapes
:2

Identity_4�
AssignVariableOp_4AssignVariableOpassignvariableop_4_adam_iterIdentity_4:output:0*
_output_shapes
 *
dtype0	2
AssignVariableOp_4\

Identity_5IdentityRestoreV2:tensors:5*
T0*
_output_shapes
:2

Identity_5�
AssignVariableOp_5AssignVariableOpassignvariableop_5_adam_beta_1Identity_5:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_5\

Identity_6IdentityRestoreV2:tensors:6*
T0*
_output_shapes
:2

Identity_6�
AssignVariableOp_6AssignVariableOpassignvariableop_6_adam_beta_2Identity_6:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_6\

Identity_7IdentityRestoreV2:tensors:7*
T0*
_output_shapes
:2

Identity_7�
AssignVariableOp_7AssignVariableOpassignvariableop_7_adam_decayIdentity_7:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_7\

Identity_8IdentityRestoreV2:tensors:8*
T0*
_output_shapes
:2

Identity_8�
AssignVariableOp_8AssignVariableOp%assignvariableop_8_adam_learning_rateIdentity_8:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_8\

Identity_9IdentityRestoreV2:tensors:9*
T0*
_output_shapes
:2

Identity_9�
AssignVariableOp_9AssignVariableOpassignvariableop_9_totalIdentity_9:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_9_
Identity_10IdentityRestoreV2:tensors:10*
T0*
_output_shapes
:2
Identity_10�
AssignVariableOp_10AssignVariableOpassignvariableop_10_countIdentity_10:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_10_
Identity_11IdentityRestoreV2:tensors:11*
T0*
_output_shapes
:2
Identity_11�
AssignVariableOp_11AssignVariableOp'assignvariableop_11_adam_conv1_kernel_mIdentity_11:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_11_
Identity_12IdentityRestoreV2:tensors:12*
T0*
_output_shapes
:2
Identity_12�
AssignVariableOp_12AssignVariableOp%assignvariableop_12_adam_conv1_bias_mIdentity_12:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_12_
Identity_13IdentityRestoreV2:tensors:13*
T0*
_output_shapes
:2
Identity_13�
AssignVariableOp_13AssignVariableOp)assignvariableop_13_adam_softmax_kernel_mIdentity_13:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_13_
Identity_14IdentityRestoreV2:tensors:14*
T0*
_output_shapes
:2
Identity_14�
AssignVariableOp_14AssignVariableOp'assignvariableop_14_adam_softmax_bias_mIdentity_14:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_14_
Identity_15IdentityRestoreV2:tensors:15*
T0*
_output_shapes
:2
Identity_15�
AssignVariableOp_15AssignVariableOp'assignvariableop_15_adam_conv1_kernel_vIdentity_15:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_15_
Identity_16IdentityRestoreV2:tensors:16*
T0*
_output_shapes
:2
Identity_16�
AssignVariableOp_16AssignVariableOp%assignvariableop_16_adam_conv1_bias_vIdentity_16:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_16_
Identity_17IdentityRestoreV2:tensors:17*
T0*
_output_shapes
:2
Identity_17�
AssignVariableOp_17AssignVariableOp)assignvariableop_17_adam_softmax_kernel_vIdentity_17:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_17_
Identity_18IdentityRestoreV2:tensors:18*
T0*
_output_shapes
:2
Identity_18�
AssignVariableOp_18AssignVariableOp'assignvariableop_18_adam_softmax_bias_vIdentity_18:output:0*
_output_shapes
 *
dtype02
AssignVariableOp_18�
RestoreV2_1/tensor_namesConst"/device:CPU:0*
_output_shapes
:*
dtype0*1
value(B&B_CHECKPOINTABLE_OBJECT_GRAPH2
RestoreV2_1/tensor_names�
RestoreV2_1/shape_and_slicesConst"/device:CPU:0*
_output_shapes
:*
dtype0*
valueB
B 2
RestoreV2_1/shape_and_slices�
RestoreV2_1	RestoreV2file_prefix!RestoreV2_1/tensor_names:output:0%RestoreV2_1/shape_and_slices:output:0
^RestoreV2"/device:CPU:0*
_output_shapes
:*
dtypes
22
RestoreV2_19
NoOpNoOp"/device:CPU:0*
_output_shapes
 2
NoOp�
Identity_19Identityfile_prefix^AssignVariableOp^AssignVariableOp_1^AssignVariableOp_10^AssignVariableOp_11^AssignVariableOp_12^AssignVariableOp_13^AssignVariableOp_14^AssignVariableOp_15^AssignVariableOp_16^AssignVariableOp_17^AssignVariableOp_18^AssignVariableOp_2^AssignVariableOp_3^AssignVariableOp_4^AssignVariableOp_5^AssignVariableOp_6^AssignVariableOp_7^AssignVariableOp_8^AssignVariableOp_9^NoOp"/device:CPU:0*
T0*
_output_shapes
: 2
Identity_19�
Identity_20IdentityIdentity_19:output:0^AssignVariableOp^AssignVariableOp_1^AssignVariableOp_10^AssignVariableOp_11^AssignVariableOp_12^AssignVariableOp_13^AssignVariableOp_14^AssignVariableOp_15^AssignVariableOp_16^AssignVariableOp_17^AssignVariableOp_18^AssignVariableOp_2^AssignVariableOp_3^AssignVariableOp_4^AssignVariableOp_5^AssignVariableOp_6^AssignVariableOp_7^AssignVariableOp_8^AssignVariableOp_9
^RestoreV2^RestoreV2_1*
T0*
_output_shapes
: 2
Identity_20"#
identity_20Identity_20:output:0*a
_input_shapesP
N: :::::::::::::::::::2$
AssignVariableOpAssignVariableOp2(
AssignVariableOp_1AssignVariableOp_12*
AssignVariableOp_10AssignVariableOp_102*
AssignVariableOp_11AssignVariableOp_112*
AssignVariableOp_12AssignVariableOp_122*
AssignVariableOp_13AssignVariableOp_132*
AssignVariableOp_14AssignVariableOp_142*
AssignVariableOp_15AssignVariableOp_152*
AssignVariableOp_16AssignVariableOp_162*
AssignVariableOp_17AssignVariableOp_172*
AssignVariableOp_18AssignVariableOp_182(
AssignVariableOp_2AssignVariableOp_22(
AssignVariableOp_3AssignVariableOp_32(
AssignVariableOp_4AssignVariableOp_42(
AssignVariableOp_5AssignVariableOp_52(
AssignVariableOp_6AssignVariableOp_62(
AssignVariableOp_7AssignVariableOp_72(
AssignVariableOp_8AssignVariableOp_82(
AssignVariableOp_9AssignVariableOp_92
	RestoreV2	RestoreV22
RestoreV2_1RestoreV2_1:+ '
%
_user_specified_namefile_prefix"�L
saver_filename:0StatefulPartitionedCall_1:0StatefulPartitionedCall_28"
saved_model_main_op

NoOp*>
__saved_model_init_op%#
__saved_model_init_op

NoOp*�
serving_default�
K
Conv1_input<
serving_default_Conv1_input:0���������;
Softmax0
StatefulPartitionedCall:0���������
tensorflow/serving/predict:�}
�
layer-0
layer_with_weights-0
layer-1
layer-2
layer_with_weights-1
layer-3
	optimizer
	variables
trainable_variables
regularization_losses
		keras_api


signatures
*D&call_and_return_all_conditional_losses
E_default_save_signature
F__call__"�
_tf_keras_sequential�{"class_name": "Sequential", "name": "sequential", "trainable": true, "expects_training_arg": true, "dtype": "float32", "batch_input_shape": null, "config": {"name": "sequential", "layers": [{"class_name": "Conv2D", "config": {"name": "Conv1", "trainable": true, "batch_input_shape": [null, 28, 28, 1], "dtype": "float32", "filters": 8, "kernel_size": [3, 3], "strides": [2, 2], "padding": "valid", "data_format": "channels_last", "dilation_rate": [1, 1], "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}}, {"class_name": "Flatten", "config": {"name": "flatten", "trainable": true, "dtype": "float32", "data_format": "channels_last"}}, {"class_name": "Dense", "config": {"name": "Softmax", "trainable": true, "dtype": "float32", "units": 10, "activation": "softmax", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}}]}, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": 4, "max_ndim": null, "min_ndim": null, "axes": {"-1": 1}}}, "is_graph_network": true, "keras_version": "2.2.4-tf", "backend": "tensorflow", "model_config": {"class_name": "Sequential", "config": {"name": "sequential", "layers": [{"class_name": "Conv2D", "config": {"name": "Conv1", "trainable": true, "batch_input_shape": [null, 28, 28, 1], "dtype": "float32", "filters": 8, "kernel_size": [3, 3], "strides": [2, 2], "padding": "valid", "data_format": "channels_last", "dilation_rate": [1, 1], "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}}, {"class_name": "Flatten", "config": {"name": "flatten", "trainable": true, "dtype": "float32", "data_format": "channels_last"}}, {"class_name": "Dense", "config": {"name": "Softmax", "trainable": true, "dtype": "float32", "units": 10, "activation": "softmax", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}}]}}, "training_config": {"loss": "sparse_categorical_crossentropy", "metrics": ["accuracy"], "weighted_metrics": null, "sample_weight_mode": null, "loss_weights": null, "optimizer_config": {"class_name": "Adam", "config": {"name": "Adam", "learning_rate": 0.0010000000474974513, "decay": 0.0, "beta_1": 0.8999999761581421, "beta_2": 0.9990000128746033, "epsilon": 1e-07, "amsgrad": false}}}}
�"�
_tf_keras_input_layer�{"class_name": "InputLayer", "name": "Conv1_input", "dtype": "float32", "sparse": false, "ragged": false, "batch_input_shape": [null, 28, 28, 1], "config": {"batch_input_shape": [null, 28, 28, 1], "dtype": "float32", "sparse": false, "ragged": false, "name": "Conv1_input"}}
�

kernel
bias
regularization_losses
	variables
trainable_variables
	keras_api
*G&call_and_return_all_conditional_losses
H__call__"�
_tf_keras_layer�{"class_name": "Conv2D", "name": "Conv1", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": [null, 28, 28, 1], "config": {"name": "Conv1", "trainable": true, "batch_input_shape": [null, 28, 28, 1], "dtype": "float32", "filters": 8, "kernel_size": [3, 3], "strides": [2, 2], "padding": "valid", "data_format": "channels_last", "dilation_rate": [1, 1], "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": 4, "max_ndim": null, "min_ndim": null, "axes": {"-1": 1}}}}
�
regularization_losses
	variables
trainable_variables
	keras_api
*I&call_and_return_all_conditional_losses
J__call__"�
_tf_keras_layer�{"class_name": "Flatten", "name": "flatten", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": null, "config": {"name": "flatten", "trainable": true, "dtype": "float32", "data_format": "channels_last"}, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": null, "max_ndim": null, "min_ndim": 1, "axes": {}}}}
�

kernel
bias
regularization_losses
	variables
trainable_variables
	keras_api
*K&call_and_return_all_conditional_losses
L__call__"�
_tf_keras_layer�{"class_name": "Dense", "name": "Softmax", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": null, "config": {"name": "Softmax", "trainable": true, "dtype": "float32", "units": 10, "activation": "softmax", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": null, "max_ndim": null, "min_ndim": 2, "axes": {"-1": 1352}}}}
�
iter

beta_1

beta_2
	decay
learning_ratem<m=m>m?v@vAvBvC"
	optimizer
<
0
1
2
3"
trackable_list_wrapper
<
0
1
2
3"
trackable_list_wrapper
 "
trackable_list_wrapper
�

 layers
!non_trainable_variables
	variables
trainable_variables
"layer_regularization_losses
#metrics
regularization_losses
F__call__
E_default_save_signature
*D&call_and_return_all_conditional_losses
&D"call_and_return_conditional_losses"
_generic_user_object
,
Mserving_default"
signature_map
&:$2Conv1/kernel
:2
Conv1/bias
 "
trackable_list_wrapper
.
0
1"
trackable_list_wrapper
.
0
1"
trackable_list_wrapper
�

$layers
%non_trainable_variables
regularization_losses
	variables
trainable_variables
&metrics
'layer_regularization_losses
H__call__
*G&call_and_return_all_conditional_losses
&G"call_and_return_conditional_losses"
_generic_user_object
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
�

(layers
)non_trainable_variables
regularization_losses
	variables
trainable_variables
*metrics
+layer_regularization_losses
J__call__
*I&call_and_return_all_conditional_losses
&I"call_and_return_conditional_losses"
_generic_user_object
!:	�

2Softmax/kernel
:
2Softmax/bias
 "
trackable_list_wrapper
.
0
1"
trackable_list_wrapper
.
0
1"
trackable_list_wrapper
�

,layers
-non_trainable_variables
regularization_losses
	variables
trainable_variables
.metrics
/layer_regularization_losses
L__call__
*K&call_and_return_all_conditional_losses
&K"call_and_return_conditional_losses"
_generic_user_object
:	 (2	Adam/iter
: (2Adam/beta_1
: (2Adam/beta_2
: (2
Adam/decay
: (2Adam/learning_rate
5
0
1
2"
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
'
00"
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
�
	1total
	2count
3
_fn_kwargs
4regularization_losses
5	variables
6trainable_variables
7	keras_api
*N&call_and_return_all_conditional_losses
O__call__"�
_tf_keras_layer�{"class_name": "MeanMetricWrapper", "name": "accuracy", "trainable": true, "expects_training_arg": true, "dtype": "float32", "batch_input_shape": null, "config": {"name": "accuracy", "dtype": "float32"}}
:  (2total
:  (2count
 "
trackable_dict_wrapper
 "
trackable_list_wrapper
.
10
21"
trackable_list_wrapper
 "
trackable_list_wrapper
�

8layers
9non_trainable_variables
4regularization_losses
5	variables
6trainable_variables
:metrics
;layer_regularization_losses
O__call__
*N&call_and_return_all_conditional_losses
&N"call_and_return_conditional_losses"
_generic_user_object
 "
trackable_list_wrapper
.
10
21"
trackable_list_wrapper
 "
trackable_list_wrapper
 "
trackable_list_wrapper
+:)2Adam/Conv1/kernel/m
:2Adam/Conv1/bias/m
&:$	�

2Adam/Softmax/kernel/m
:
2Adam/Softmax/bias/m
+:)2Adam/Conv1/kernel/v
:2Adam/Conv1/bias/v
&:$	�

2Adam/Softmax/kernel/v
:
2Adam/Softmax/bias/v
�2�
E__inference_sequential_layer_call_and_return_conditional_losses_29913
E__inference_sequential_layer_call_and_return_conditional_losses_30012
E__inference_sequential_layer_call_and_return_conditional_losses_29902
E__inference_sequential_layer_call_and_return_conditional_losses_29992�
���
FullArgSpec1
args)�&
jself
jinputs

jtraining
jmask
varargs
 
varkw
 
defaults�
p 

 

kwonlyargs� 
kwonlydefaults� 
annotations� *
 
�2�
 __inference__wrapped_model_29836�
���
FullArgSpec
args� 
varargsjargs
varkw
 
defaults
 

kwonlyargs� 
kwonlydefaults
 
annotations� *2�/
-�*
Conv1_input���������
�2�
*__inference_sequential_layer_call_fn_30030
*__inference_sequential_layer_call_fn_29934
*__inference_sequential_layer_call_fn_30021
*__inference_sequential_layer_call_fn_29954�
���
FullArgSpec1
args)�&
jself
jinputs

jtraining
jmask
varargs
 
varkw
 
defaults�
p 

 

kwonlyargs� 
kwonlydefaults� 
annotations� *
 
�2�
@__inference_Conv1_layer_call_and_return_conditional_losses_29849�
���
FullArgSpec
args�
jself
jinputs
varargs
 
varkw
 
defaults
 

kwonlyargs� 
kwonlydefaults
 
annotations� *7�4
2�/+���������������������������
�2�
%__inference_Conv1_layer_call_fn_29857�
���
FullArgSpec
args�
jself
jinputs
varargs
 
varkw
 
defaults
 

kwonlyargs� 
kwonlydefaults
 
annotations� *7�4
2�/+���������������������������
�2�
B__inference_flatten_layer_call_and_return_conditional_losses_30036�
���
FullArgSpec
args�
jself
jinputs
varargs
 
varkw
 
defaults
 

kwonlyargs� 
kwonlydefaults
 
annotations� *
 
�2�
'__inference_flatten_layer_call_fn_30041�
���
FullArgSpec
args�
jself
jinputs
varargs
 
varkw
 
defaults
 

kwonlyargs� 
kwonlydefaults
 
annotations� *
 
�2�
B__inference_Softmax_layer_call_and_return_conditional_losses_30052�
���
FullArgSpec
args�
jself
jinputs
varargs
 
varkw
 
defaults
 

kwonlyargs� 
kwonlydefaults
 
annotations� *
 
�2�
'__inference_Softmax_layer_call_fn_30059�
���
FullArgSpec
args�
jself
jinputs
varargs
 
varkw
 
defaults
 

kwonlyargs� 
kwonlydefaults
 
annotations� *
 
6B4
#__inference_signature_wrapper_29972Conv1_input
�2��
���
FullArgSpec
args�
jself
jinputs
varargs
 
varkwjkwargs
defaults� 

kwonlyargs�

jtraining%
kwonlydefaults�

trainingp 
annotations� *
 
�2��
���
FullArgSpec
args�
jself
jinputs
varargs
 
varkwjkwargs
defaults� 

kwonlyargs�

jtraining%
kwonlydefaults�

trainingp 
annotations� *
 �
@__inference_Conv1_layer_call_and_return_conditional_losses_29849�I�F
?�<
:�7
inputs+���������������������������
� "?�<
5�2
0+���������������������������
� �
%__inference_Conv1_layer_call_fn_29857�I�F
?�<
:�7
inputs+���������������������������
� "2�/+����������������������������
B__inference_Softmax_layer_call_and_return_conditional_losses_30052]0�-
&�#
!�
inputs����������

� "%�"
�
0���������

� {
'__inference_Softmax_layer_call_fn_30059P0�-
&�#
!�
inputs����������

� "����������
�
 __inference__wrapped_model_29836w<�9
2�/
-�*
Conv1_input���������
� "1�.
,
Softmax!�
Softmax���������
�
B__inference_flatten_layer_call_and_return_conditional_losses_30036a7�4
-�*
(�%
inputs���������
� "&�#
�
0����������

� 
'__inference_flatten_layer_call_fn_30041T7�4
-�*
(�%
inputs���������
� "�����������
�
E__inference_sequential_layer_call_and_return_conditional_losses_29902sD�A
:�7
-�*
Conv1_input���������
p

 
� "%�"
�
0���������

� �
E__inference_sequential_layer_call_and_return_conditional_losses_29913sD�A
:�7
-�*
Conv1_input���������
p 

 
� "%�"
�
0���������

� �
E__inference_sequential_layer_call_and_return_conditional_losses_29992n?�<
5�2
(�%
inputs���������
p

 
� "%�"
�
0���������

� �
E__inference_sequential_layer_call_and_return_conditional_losses_30012n?�<
5�2
(�%
inputs���������
p 

 
� "%�"
�
0���������

� �
*__inference_sequential_layer_call_fn_29934fD�A
:�7
-�*
Conv1_input���������
p

 
� "����������
�
*__inference_sequential_layer_call_fn_29954fD�A
:�7
-�*
Conv1_input���������
p 

 
� "����������
�
*__inference_sequential_layer_call_fn_30021a?�<
5�2
(�%
inputs���������
p

 
� "����������
�
*__inference_sequential_layer_call_fn_30030a?�<
5�2
(�%
inputs���������
p 

 
� "����������
�
#__inference_signature_wrapper_29972�K�H
� 
A�>
<
Conv1_input-�*
Conv1_input���������"1�.
,
Softmax!�
Softmax���������
