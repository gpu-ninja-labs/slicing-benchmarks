FROM nvidia/cuda:12.2.0-devel-ubuntu22.04 AS builder
WORKDIR /slicing-benchmarks

COPY . /slicing-benchmarks
RUN make

FROM ubuntu:22.04

COPY --from=builder /slicing-benchmarks/bin/ /usr/local/bin/

ENTRYPOINT [ "sh" ]
CMD [ "-c", "/usr/local/bin/small-stresser" ]