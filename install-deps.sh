#!/bin/bash
set -e
#
# must be run as sudo; assumes the following is already installed:
#   - scons
#   - c/c++/fortran compiler
#   - cmake
#   - python and pip

# TODO: add support for other than debian-based distros

apt update
apt install -y \
  libopenmpi-dev \
  hdf5-tools \
  libhdf5-mpi-dev \
  libcurl4-openssl-dev

# apt cleanup (when building docker images)
rm -rf /var/lib/apt/lists/*

# install netcdf
curl -LO ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.6.1.tar.gz
tar -xaf netcdf-4.6.1.tar.gz
pushd netcdf-4.6.1
CC=h5pcc ./configure --enable-shared=no --prefix=/usr
make -j8
make install
popd
rm -r netcdf-4.6.1*

pip install 'numpy>=1.12.0' lxml

# install libxssm
curl -LO https://github.com/hfp/libxsmm/archive/master.tar.gz
tar xvfz master.tar.gz
pushd libxsmm-master
make generator
cp bin/libxsmm_gemm_generator /usr/bin
popd
rm -rf libxsmm-master/
