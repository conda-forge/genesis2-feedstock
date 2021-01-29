#!/usr/bin/env bash

if [[ "$target_platform" == osx* ]]; then
    CMAKE_FLAGS+=" -DCMAKE_OSX_SYSROOT=${CONDA_BUILD_SYSROOT}"
    CMAKE_FLAGS+=" -DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}"
    # Hack around https://github.com/conda-forge/gfortran_osx-64-feedstock/issues/11
    # Taken from https://github.com/awvwgk/staged-recipes/tree/dftd4/recipes/dftd4
    # See contents of fake-bin/cc1 for an explanation
    export PATH="${PATH}:${RECIPE_DIR}/fake-bin"
fi

mkdir build
cd build

cmake \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DUSE_MPI=OFF \
    ..

make -j${CPU_COUNT} install

if [[ "$mpi" != "nompi" ]]; then
     cd ..
     mkdir build_mpi
     cd build_mpi
     cmake \
         -DCMAKE_INSTALL_PREFIX=${PREFIX} \
         -DUSE_MPI=ON \
         ..

     make -j${CPU_COUNT} install
fi
