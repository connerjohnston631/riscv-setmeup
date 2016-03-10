#!/bin/bash
read -p "enter the name of the directory:  " dir

if [ -d "$dir" ]; then
  echo 'cannot use a directory that already exists'
  exit 1
fi

echo 'making directory '$dir
mkdir $dir

echo 'entering directory '$dir 
cd $dir

echo 'cloning the rocket repo...'
git clone https://github.com/ucb-bar/rocket-chip.git 

echo 'going into rocket chip directory'
cd rocket-chip

echo 'updating the submodule...' 
git submodule update --init 

echo 'going into riscv-tools directory'
rm -rf riscv-tools
git clone https://github.com/riscv/riscv-tools.git

cd riscv-tools
git submodule update --init --recursive

echo 'exporting RISCV and PATH variable'
export RISCV=$(pwd)
export PATH=$(pwd)/bin
echo 'installing the RISCV toolchain'
echo ''
echo 'downloading required UBUNTU packages'
apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc

echo 'running build script...'
./build.sh

echo 'testing...'
cd ../
echo -e '#include <stdio.h>\n int main(void) { printf("Hello world!\\n"); return 0; }' > hello.c
riscv64-unknown-elf-gcc -o hello hello.c



