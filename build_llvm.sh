#!/usr/bin/env bash
set -euo pipefail

SRC_DIR=/root/llvm/llvm-project/llvm
BUILD_DIR=/root/llvm/build

mkdir -p "${BUILD_DIR}"

cmake                                                   \
  -S "${SRC_DIR}"                                       \
  -B "${BUILD_DIR}"                                     \
  -G Ninja                                              \
  -DCMAKE_C_COMPILER=/usr/bin/x86_64-linux-gnu-gcc-11   \
  -DCMAKE_CXX_COMPILER=/usr/bin/x86_64-linux-gnu-g++-11 \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo                     \
  -DLLVM_ENABLE_PROJECTS="clang"                        \
  -DLLVM_TARGETS_TO_BUILD="RISCV;EZRV"                  \
  -DLLVM_ENABLE_ASSERTIONS="true"                       \
  -DLLVM_USE_LINKER=lld                                 \
  -DLLVM_USE_SPLIT_DWARF=ON                             \
  -DLLVM_LINK_LLVM_DYLIB=ON

cmake --build "${BUILD_DIR}"
