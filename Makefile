NVCC = nvcc
NVCCFLAGS =

CUDA_SRCS = $(shell find src -name "*.cu")

all: bin/small-stresser

bin/small-stresser: src/small-stresser/small-stresser.cu
	mkdir -p bin
	$(NVCC) $(NVCCFLAGS) -o $@ $<

format: $(CUDA_SRCS)
	clang-format -i $^

clean:
	rm -rf bin

.PHONY: all format clean