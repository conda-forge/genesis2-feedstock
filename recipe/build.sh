#!/usr/bin/env bash

# for cross compiling using openmpi
export OPAL_PREFIX=$PREFIX

if [[ "$target_platform" == osx* ]]; then
    # Hack around https://github.com/conda-forge/gfortran_osx-64-feedstock/issues/11
    # Taken from https://github.com/awvwgk/staged-recipes/tree/dftd4/recipes/dftd4
    # See contents of fake-bin/cc1 for an explanation
    export PATH="${PATH}:${RECIPE_DIR}/fake-bin"
fi

if [[ "$mpi" != "nompi" ]]; then
    # Fix for cmake bug when cross-compiling
    export FFLAGS="$FFLAGS $LDFLAGS"
    export FC=mpifort
fi

mkdir build
cd build

cmake \
    ${CMAKE_ARGS} \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DUSE_MPI=OFF \
    ..

make -j${CPU_COUNT} install

if [[ "$mpi" != "nompi" ]]; then
     cd ..
     mkdir build_mpi
     cd build_mpi
     cmake \
    	 ${CMAKE_ARGS} \
         -DCMAKE_INSTALL_PREFIX=${PREFIX} \
         -DUSE_MPI=ON \
         .. || \
     { cat $SRC_DIR/build_mpi/CMakeFiles/CMakeOutput.log; \
       cat $SRC_DIR/build_mpi/CMakeFiles/CMakeError.log; exit 1; }

     make -j${CPU_COUNT} install
fi
