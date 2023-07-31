/* SPDX-License-Identifier: Apache-2.0
 *
 * Copyright 2023 Damian Peckett <damian@peckett>.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <chrono>
#include <cstdint>
#include <cuda.h>
#include <iostream>
#include <vector>

__global__ void add(int32_t n, int32_t *x, int32_t *y) {
  auto index = threadIdx.x;
  auto stride = blockDim.x;

  for (auto i = index; i < n; i += stride)
    y[i] = x[i] + y[i];
}

int main() {
  auto N = 1 << 20; // 1M elements
  int32_t *x, *y;

  std::cout << "Allocating memory" << std::endl;

  cudaMallocManaged(&x, N * sizeof(int32_t));
  cudaMallocManaged(&y, N * sizeof(int32_t));

  // initialize x and y arrays on the host
  for (auto i = 0; i < N; i++) {
    x[i] = 1;
    y[i] = 2;
  }

  auto start = std::chrono::high_resolution_clock::now();

  std::cout << "Beginning stress test" << std::endl;

  // Run kernel on 1M elements on the GPU
  int64_t num_iterations = 100000000LL;
  for (auto i = 0; i < num_iterations; ++i) {
    add<<<1, 256>>>(N, x, y);
    cudaDeviceSynchronize();

    // Print time elapsed every few seconds
    if (i > 0 && i % 1000 == 0) {
      auto end = std::chrono::high_resolution_clock::now();
      std::chrono::duration<double> elapsed = end - start;
      start = end;

      std::cout << "Iterations per second: " << (1000.0 / elapsed.count())
                << std::endl;
    }
  }

  cudaFree(x);
  cudaFree(y);

  return 0;
}
