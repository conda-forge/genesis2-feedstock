#!/usr/bin/env bash

mpi_arg="OFF"
if [[ "$mpi" != "nompi" ]]; then
  mpi_arg="ON"
fi

mkdir build
cd build

cmake \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DUSE_MPI=${mpi_arg} \
    ..

make -j${CPU_COUNT} install

