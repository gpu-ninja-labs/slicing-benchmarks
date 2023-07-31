# slicing-benchmarks

Some GPU slicing numbers everyone should now.

## Prerequisites

* Kubernetes cluster with the [NVIDIA DRA Driver](https://gitlab.com/nvidia/cloud-native/k8s-dra-driver).

## Run Tests

### Exclusive

```shell
docker run --gpus=all --rm -it ghcr.io/gpu-ninja/slicing-benchmarks:latest
```

### Shared

Choose the slicing configuration you want from the `config` folder and apply it to your cluster.

```shell
kubectl apply -f deploy -f config/timeslicing.yaml
```

The benchmark will start automatically and you can get the results from the logs of the pods.

## TODO

* [ ] Add more benchmarks (particularly those that stress compute and memory).
* [ ] Add more slicing configurations (eg. MIG)
* [ ] Add more GPUs (eg. A100/H100)