Bootstrap: docker
From: sl:7
IncludeCmd: yes

%labels
AUTHOR manigrasso.floriano@ucy.ac.cy
DESCRIPTION Based Scientific Linux 7, contains the ROCm libraries required from QUDA

%files
install_quda.sh 

%post
ls -lrth /*

# Needed for rocm-dev
yum -y install  https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/l/libbabeltrace-1.2.4-3.el7.x86_64.rpm

# Install required base build and packaging commands for ROCm
yum -y install babeltrace \
       bc \
       bridge-utils \
       cmake \
       cmake3 \
       devscripts \
       dkms \
       doxygen \
       dpkg \
       dpkg-dev \
       dpkg-perl \
       elfutils-libelf-devel \
       expect \
       file \
       git \
       java-1.8.0-openjdk \
       gettext \
       gcc-c++ \
       libgcc glibc.i686 \
       libcxx-devel \
       ncurses \
       ncurses-base \
       ncurses-libs \
       numactl-devel \
       numactl-libs \
       libssh \
       libunwind-devel \
       libunwind \
       llvm \
       llvm-libs \
       make \
       openssl \
       openssl-libs \
       openssh \
       openssh-clients \
       pciutils \
       pciutils-devel \
       pciutils-libs \
       python \
       python-pip \
       python-devel \
       pkgconfig \
       pth \
       qemu-kvm \
       re2c \
       kmod \
       file \
       rpm \
       rpm-build \
       subversion \
       wget \
       eigen3

yum clean all

####### Define the default language

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

####### GNU 7.3.1 #######

yum -y update
yum install -y yum-utils \
    	       yum-conf-repos \
	       yum-conf-softwarecollections
yum -y update
yum-config-manager --enable rhel-server-rhscl-7-rpms

yum -y install devtoolset-7

yum install -y devtoolset-7-libatomic-devel devtoolset-7-elfutils-libelf-devel
yum clean all

############### GNU 7.3.1 General environment variables settings ##################

export PATH=/opt/rh/devtoolset-7/root/usr/bin:${PATH}
export LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib:${LD_LIBRARY_PATH}

#### Extra packages for network and MPI #######

yum -y install epel-release                
yum -y install libibverbs.x86_64
yum -y install libpsm2-devel.x86_64   
yum -y install opa-fastfabric.x86_64
yum -y install libfabric-devel.x86_64
yum -y install infinipath-psm-devel.x86_64
yum -y install libsysfs.x86_64
yum -y install slurm-pmi-devel.x86_64
yum -y install libffi-devel.x86_64
yum -y install rdma-core-devel.x86_64

############################ OpenMPI 3.1.4 installation ############################

mkdir -p /workdir
cd /workdir
version=3.1
build=4
wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-${version}.${build}.tar.gz
tar -xvf /workdir/openmpi-${version}.${build}.tar.gz
rm -rf /workdir/openmpi-${version}.${build}.tar.gz
cd openmpi-${version}.${build}
export FC="gfortran"
export CC="gcc"
export CFLAGS="-g -O2 -march=core-avx2"
export CXXFLAGS="$CFLAGS"
export FCFLAGS="-g -O2 -march=core-avx2"
export LDFLAGS="-g -O2 -ldl -march=core-avx2"
./configure --prefix=/opt/openmpi/${version}.${build} FC=gfortran CC=gcc  --with-psm2=yes --with-memory-manager=none  --enable-static=yes --with-pmix --with-pmi --with-pmi-libdir="/usr/lib64/" --enable-shared --with-verbs --enable-mpirun-prefix-by-default --disable-dlopen

make -j 2
make install

#Export OpenMPI library paths required at building time by QUDA
export PATH=/opt/openmpi/${version}.${build}/bin:${PATH}
export LD_LIBRARY_PATH=/opt/openmpi/${version}.${build}/lib:${LD_LIBRARY_PATH}
export MANPATH=/opt/openmpi/${version}.${build}/share/man:${MANPATH}
export INFOPATH=/opt/openmpi/${version}.${build}/share/info:${INFOPATH}

############################ Add ROCm repos and compile ############################
echo '[ROCm]
name=ROCm
baseurl=https://repo.radeon.com/rocm/yum/4.1
enabled=1
gpgcheck=1
gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key' > /etc/yum.repos.d/rocm.repo


yum clean all

yum -y install rocm-dev \
       	       hipblas \
	       hipcub \
	       hipsparse \
	       miopen-hip \
	       miopengemm \
	       rccl \
	       rocblas \
	       rocfft \
	       rocprim \
	       rocrand \
	       rocsolver

yum clean all


export PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin:/opt/rocm/bin:/opt/rocm/hcc/bin:${PATH:+:${PATH}}
export MANPATH=/opt/rh/devtoolset-7/root/usr/share/man:${MANPATH}
export INFOPATH=/opt/rh/devtoolset-7/root/usr/share/info${INFOPATH:+:${INFOPATH}}
export PCP_DIR=/opt/rh/devtoolset-7/root
export PERL5LIB=/opt/rh/devtoolset-7/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-7/root/usr/lib/perl5:/opt/rh/devtoolset-7/root//usr/share/perl5/
export LD_LIBRARY_PATH=/opt/rocm/lib:/usr/local/lib:/opt/rh/devtoolset-7/root$rpmlibdir$rpmlibdir32${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PYTHONPATH=/opt/rh/devtoolset-7/root/usr/lib64/python$pythonvers/site-packages:/opt/rh/devtoolset-7/root/usr/lib/python$pythonvers/
export LDFLAGS="-Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib64 -Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib"
export PATH=/opt/rh/devtoolset-7/root/usr/bin:${PATH}
export LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib:${LD_LIBRARY_PATH}


############################ Get cmake 3.15 required by QUDA ############################

yum install -y ncurses-devel
cd /workdir
version=3.15
build=1
wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz
tar -xzvf cmake-$version.$build.tar.gz
rm -rf cmake-$version.$build.tar.gz
cd cmake-$version.$build/
./bootstrap
make -j 2
make install

#Check cmake version
cmake --version

########################## Compile QUDA with ROCm support ################################

yum install -y eigen3
cd /workdir
git clone https://github.com/lattice/quda.git
cd /workdir/quda
mv /install_quda.sh /workdir/quda/.
git checkout feature/hip-compile-fixes
#bash install_quda.sh


%environment

export PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin:/opt/rocm/bin:/opt/rocm/hcc/bin:${PATH:+:${PATH}}
export MANPATH=/opt/rh/devtoolset-7/root/usr/share/man:${MANPATH}
export INFOPATH=/opt/rh/devtoolset-7/root/usr/share/info${INFOPATH:+:${INFOPATH}}
export PCP_DIR=/opt/rh/devtoolset-7/root
export PERL5LIB=/opt/rh/devtoolset-7/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-7/root/usr/lib/perl5:/opt/rh/devtoolset-7/root//usr/share/perl5/
export LD_LIBRARY_PATH=/opt/rocm/lib:/usr/local/lib:/opt/rh/devtoolset-7/root$rpmlibdir$rpmlibdir32${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PYTHONPATH=/opt/rh/devtoolset-7/root/usr/lib64/python$pythonvers/site-packages:/opt/rh/devtoolset-7/root/usr/lib/python$pythonvers/
export LDFLAGS="-Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib64 -Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib"
export PATH=/opt/rh/devtoolset-7/root/usr/bin:${PATH}
export LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib:${LD_LIBRARY_PATH}


version=3.1
build=4
export PATH=/opt/openmpi/${version}.${build}/bin:${PATH}
export LD_LIBRARY_PATH=/opt/openmpi/${version}.${build}/lib:${LD_LIBRARY_PATH}
export MANPATH=/opt/openmpi/${version}.${build}/share/man:${MANPATH}
export INFOPATH=/opt/openmpi/${version}.${build}/share/info:${INFOPATH}

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8