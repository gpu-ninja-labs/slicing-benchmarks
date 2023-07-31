# Small Stresser on RTX 4090

## Exclusive

### Overview

```
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.54.03              Driver Version: 535.54.03    CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 4090        Off | 00000000:05:00.0 Off |                  Off |
| 31%   39C    P2              77W / 450W |    524MiB / 24564MiB |     99%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A    338932      C   /usr/local/bin/small-stresser               384MiB |
+---------------------------------------------------------------------------------------+
```

### Results

Mean performance: 1971.78 total iterations per second.

```
Iterations per second: 1975.79
Iterations per second: 1975.49
Iterations per second: 1974.09
Iterations per second: 1975.61
Iterations per second: 1975.9
```

## Shared (MPS)

### Overview

```
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.54.03              Driver Version: 535.54.03    CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 4090        Off | 00000000:05:00.0 Off |                  Off |
| 31%   39C    P2              78W / 450W |    933MiB / 24564MiB |    100%   E. Process |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A    342668    M+C   /usr/local/bin/small-stresser               382MiB |
|    0   N/A  N/A    342669    M+C   /usr/local/bin/small-stresser               382MiB |
|    0   N/A  N/A    342728      C   nvidia-cuda-mps-server                       28MiB |
+---------------------------------------------------------------------------------------+
```

### Results

Mean performance: 4039.70 total iterations per second.

#### Pod 1

```
Iterations per second: 2026.09
Iterations per second: 2027.49
Iterations per second: 2001.5
Iterations per second: 2024.73
Iterations per second: 2026.22
```

#### Pod 2

```
Iterations per second: 2031.26
Iterations per second: 2031.66
Iterations per second: 2010.32
Iterations per second: 2005.96
Iterations per second: 2013.28
```

## Shared (Time Slicing)

Using default time slice slot duration.

### Overview

```
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.54.03              Driver Version: 535.54.03    CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 4090        Off | 00000000:05:00.0 Off |                  Off |
| 31%   39C    P2              78W / 450W |    914MiB / 24564MiB |    100%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A    345469      C   /usr/local/bin/small-stresser               384MiB |
|    0   N/A  N/A    345470      C   /usr/local/bin/small-stresser               384MiB |
+---------------------------------------------------------------------------------------+
```

### Results

Mean performance: 1778.58 total iterations per second.

#### Pod 1

```
Iterations per second: 889.21
Iterations per second: 889.407
Iterations per second: 889.266
Iterations per second: 889.272
Iterations per second: 889.295
```

#### Pod 2

```
Iterations per second: 889.25
Iterations per second: 889.254
Iterations per second: 889.258
Iterations per second: 889.333
Iterations per second: 889.371
```

## Conclusion

For small workloads that don't saturate compute or memory MPS is an incredible performance boost over timeslicing and even exclusive mode.

The reason for this is MPS can run kernels from multiple processes at the same time (assuming they can all fit on the GPU) whereas timeslicing and exclusive mode can only run kernels from one process at a time.

From earlier NVIDIA documentation on MPS many of us were under the impression that it would reduce CUDA memory overheads but in practice this doesn't really seem to be achieved (or is more of a theoretical concern for small numbers of slices). So MPS consumes pretty much the same memory as time slicing but is MUCH faster for non-saturating compute workloads.

From the earliest MPS documentation I can find it appears it was intended as a way to allow running multiple HPC ranks (that weren't utilizing the hardware well) on the same GPU. For this usecase MPS seems to be a great solution.