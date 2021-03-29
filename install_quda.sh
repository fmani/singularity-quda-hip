### Based on https://github.com/lattice/quda/blob/feature/hip-compile-fixes/HIP_NOTES.md

export SM="sm_70" # not actually used
export INSTALLDIR=/workdir/quda
export HIP_CXXFLAGS="-D__gfx906__ -I/opt/rocm/hiprand/include -I/opt/rocm/rocrand/include -I/opt/rocm/hipblas/include -I/opt/rocm/hipcub/include -I/opt/rocm/rocprim/include -I/opt/rocm/rocblas/include/ -I/opt/rocm/rocfft/include/ --amdgpu-target=gfx906" 
export HIP_LDFLAGS="-D__gfx906 -Wl,-rpath=/opt/rocm/hiprand/lib -L/opt/rocm/hiprand/lib -Wl,-rpath=/opt/rocm/rocfft/lib -L/opt/rocm/rocfft/lib -lhiprand -lrocfft -lrocfft-device -Wl,-rpath=/opt/rocm/hipblas/lib -L/opt/rocm/hipblas/lib -lhipblas -Wl,-rpath=/opt/rocm/rocblas/lib -L/opt/rocm/rocblas/lib -lrocblas -Wl,-rpath=/opt/rocm/hip/lib"

rm -rf ${INSTALLDIR}/build
mkdir ${INSTALLDIR}/build
cd ${INSTALLDIR}/build

cmake -DQUDA_TARGET_TYPE=HIP -DCMAKE_EXE_LINKER_FLAGS="${HIP_LDFLAGS}  -lstdc++" -DCMAKE_CXX_FLAGS="-std=c++14 ${CXXSYSTEM_INCLUDES} ${HIP_CXXFLAGS}" -DCMAKE_CXX_COMPILER="hipcc"  -DQUDA_DOWNLOAD_EIGEN=OFF -DQUDA_DIRAC_CLOVER=OFF -DQUDA_DIRAC_CLOVER_HASENBUSCH=OFF -DQUDA_DIRAC_DOMAIN_WALL=OFF -DQUDA_DIRAC_NDEG_TWISTED_MASS=OFF -DQUDA_DIRAC_STAGGERED=OFF -DQUDA_DIRAC_TWISTED_MASS=OFF -DQUDA_DIRAC_WILSON=OFF -DQUDA_MPI=ON -DQUDA_MULTIGRID=ON  ../.

make -j 4
