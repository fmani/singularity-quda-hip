FROM sl:7

# Needed for rocm-dev
RUN yum -y install  https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/l/libbabeltrace-1.2.4-3.el7.x86_64.rpm

# Install required base build and packaging commands for ROCm
RUN yum -y install babeltrace \
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

RUN yum clean all

####### Define the default language

ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

####### GNU 7.3.1 #######

RUN yum -y update
RUN yum install -y yum-utils \
    	       yum-conf-repos \
	       yum-conf-softwarecollections
RUN yum -y update
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms

RUN yum -y install devtoolset-7

RUN yum install -y devtoolset-7-libatomic-devel devtoolset-7-elfutils-libelf-devel
RUN yum clean all

############### GNU 7.3.1 General environment variables settings ##################

ENV PATH=/opt/rh/devtoolset-7/root/usr/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib:${LD_LIBRARY_PATH}

#### Extra packages for network and MPI #######

RUN yum -y install epel-release                
RUN yum -y install libibverbs.x86_64
RUN yum -y install libpsm2-devel.x86_64   
RUN yum -y install opa-fastfabric.x86_64
RUN yum -y install libfabric-devel.x86_64
RUN yum -y install infinipath-psm-devel.x86_64
RUN yum -y install libsysfs.x86_64
RUN yum -y install slurm-pmi-devel.x86_64
RUN yum -y install libffi-devel.x86_64
RUN yum -y install rdma-core-devel.x86_64

############################ OpenMPI 3.1.4 installation ############################

mkdir /workdir
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
RUN name=ROCm
RUN baseurl=https://repo.radeon.com/rocm/yum/4.0
RUN enabled=1
RUN gpgcheck=1
RUN gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key' > /etc/yum.repos.d/rocm.repo


RUN yum clean all

RUN yum -y install rocm-dev \
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

RUN yum clean all


ENV PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin:/opt/rocm/bin:/opt/rocm/hcc/bin:${PATH:+:${PATH}}
ENV MANPATH=/opt/rh/devtoolset-7/root/usr/share/man:${MANPATH}
ENV INFOPATH=/opt/rh/devtoolset-7/root/usr/share/info${INFOPATH:+:${INFOPATH}}
ENV PCP_DIR=/opt/rh/devtoolset-7/root
ENV PERL5LIB=/opt/rh/devtoolset-7/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-7/root/usr/lib/perl5:/opt/rh/devtoolset-7/root//usr/share/perl5/
ENV LD_LIBRARY_PATH=/opt/rocm/lib:/usr/local/lib:/opt/rh/devtoolset-7/root$rpmlibdir$rpmlibdir32${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV PYTHONPATH=/opt/rh/devtoolset-7/root/usr/lib64/python$pythonvers/site-packages:/opt/rh/devtoolset-7/root/usr/lib/python$pythonvers/
ENV LDFLAGS="-Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib64 -Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib"
ENV PATH=/opt/rh/devtoolset-7/root/usr/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib:${LD_LIBRARY_PATH}


############################ Get cmake 3.15 required by QUDA ############################

RUN yum install -y ncurses-devel
RUN cd /workdir
RUN version=3.15
RUN build=1
RUN wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz
RUN tar -xzvf cmake-$version.$build.tar.gz
RUN rm -rf cmake-$version.$build.tar.gz
RUN cd cmake-$version.$build/
RUN ./bootstrap
RUN make -j 2
RUN make install

#Check cmake version
RUN cmake --version

########################## Compile QUDA with ROCm support ################################

RUN yum install -y eigen3
RUN cd /workdir
RUN git clone https://github.com/lattice/quda.git
RUN cd /workdir/quda
RUN mv /data/install_quda.sh /workdir/quda/.
RUN git checkout feature/hip-compile-fixes
#bash install_quda.sh


%environment

ENV PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin:/opt/rocm/bin:/opt/rocm/hcc/bin:${PATH:+:${PATH}}
ENV MANPATH=/opt/rh/devtoolset-7/root/usr/share/man:${MANPATH}
ENV INFOPATH=/opt/rh/devtoolset-7/root/usr/share/info${INFOPATH:+:${INFOPATH}}
ENV PCP_DIR=/opt/rh/devtoolset-7/root
ENV PERL5LIB=/opt/rh/devtoolset-7/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-7/root/usr/lib/perl5:/opt/rh/devtoolset-7/root//usr/share/perl5/
ENV LD_LIBRARY_PATH=/opt/rocm/lib:/usr/local/lib:/opt/rh/devtoolset-7/root$rpmlibdir$rpmlibdir32${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV PYTHONPATH=/opt/rh/devtoolset-7/root/usr/lib64/python$pythonvers/site-packages:/opt/rh/devtoolset-7/root/usr/lib/python$pythonvers/
ENV LDFLAGS="-Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib64 -Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib"
ENV PATH=/opt/rh/devtoolset-7/root/usr/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib:${LD_LIBRARY_PATH}


version=3.1
build=4
ENV PATH=/opt/openmpi/${version}.${build}/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/openmpi/${version}.${build}/lib:${LD_LIBRARY_PATH}
ENV MANPATH=/opt/openmpi/${version}.${build}/share/man:${MANPATH}
ENV INFOPATH=/opt/openmpi/${version}.${build}/share/info:${INFOPATH}

ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8