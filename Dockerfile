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

RUN export LC_CTYPE=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8

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

RUN export PATH=/opt/rh/devtoolset-7/root/usr/bin:${PATH}
RUN export LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib:${LD_LIBRARY_PATH}

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

RUN mkdir /workdir
WORKDIR /workdir
RUN wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.4.tar.gz
RUN tar -xvf /workdir/openmpi-3.1.4.tar.gz
WORKDIR /workdir/openmpi-3.1.4
ARG FC="gfortran"
ARG CC="gcc"
ARG CFLAGS="-g -O2 -march=core-avx2"
ARG CXXFLAGS="$CFLAGS"
ARG FCFLAGS="-g -O2 -march=core-avx2"
ARG LDFLAGS="-g -O2 -ldl -march=core-avx2"
RUN ./configure --prefix=/opt/openmpi/3.1.4 FC=gfortran CC=gcc  --with-psm2=yes --with-memory-manager=none --enable-static=yes --with-pmix --with-pmi --with-pmi-libdir="/usr/lib64/" --enable-shared --with-verbs --enable-mpirun-prefix-by-default --disable-dlopen

RUN make -j 8
RUN make install

#Export OpenMPI library paths required at building time by QUDA
ARG PATH=/opt/openmpi/3.1.4/bin:${PATH}
ARG LD_LIBRARY_PATH=/opt/openmpi/3.1.4/lib:${LD_LIBRARY_PATH}
ARG MANPATH=/opt/openmpi/3.1.4/share/man:${MANPATH}
ARG INFOPATH=/opt/openmpi/3.1.4/share/info:${INFOPATH}

############################ Add ROCm repos and compile ############################
ARG name=ROCm
ARG baseurl=https://repo.radeon.com/rocm/yum/4.0
ARG enabled=1
ARG gpgcheck=1
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


ARG PATH=/opt/rh/devtoolset-7/root/usr/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin:/opt/rocm/bin:/opt/rocm/hcc/bin:${PATH:+:${PATH}}
ARG MANPATH=/opt/rh/devtoolset-7/root/usr/share/man:${MANPATH}
ARG INFOPATH=/opt/rh/devtoolset-7/root/usr/share/info${INFOPATH:+:${INFOPATH}}
ARG PCP_DIR=/opt/rh/devtoolset-7/root
ARG PERL5LIB=/opt/rh/devtoolset-7/root//usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-7/root/usr/lib/perl5:/opt/rh/devtoolset-7/root//usr/share/perl5/
ARG LD_LIBRARY_PATH=/opt/rocm/lib:/usr/local/lib:/opt/rh/devtoolset-7/root$rpmlibdir$rpmlibdir32${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ARG PYTHONPATH=/opt/rh/devtoolset-7/root/usr/lib64/python$pythonvers/site-packages:/opt/rh/devtoolset-7/root/usr/lib/python$pythonvers/
ARG LDFLAGS="-Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib64 -Wl,-rpath=/opt/rh/devtoolset-7/root/usr/lib"
ARG PATH=/opt/rh/devtoolset-7/root/usr/bin:${PATH}
ARG LD_LIBRARY_PATH=/opt/rh/devtoolset-7/root/usr/lib:${LD_LIBRARY_PATH}


############################ Get cmake 3.15 required by QUDA ############################

RUN yum install -y ncurses-devel
WORKDIR /workdir
ARG version=3.15
ARG build=1
RUN wget https://cmake.org/files/v3.15/cmake-3.15.1.tar.gz
RUN tar -xzvf cmake-3.15.1.tar.gz
RUN rm -rf cmake-3.15.1.tar.gz
WORKDIR /workdir/cmake-3.15.1/
RUN ./bootstrap
RUN make -j 2
RUN make install

#Check cmake version
RUN cmake --version

########################## Compile QUDA with ROCm support ################################

RUN yum install -y eigen3
WORKDIR /workdir
RUN git clone https://github.com/lattice/quda.git
WORKDIR /workdir/quda
RUN mv /data/install_quda.sh /workdir/quda/.
RUN git checkout feature/hip-compile-fixes
#bash install_quda.sh




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


ARG version=3.1
ARG build=4
ENV PATH=/opt/openmpi/3.1.4/bin:${PATH}
ENV LD_LIBRARY_PATH=/opt/openmpi/3.1.4/lib:${LD_LIBRARY_PATH}
ENV MANPATH=/opt/openmpi/3.1.4/share/man:${MANPATH}
ENV INFOPATH=/opt/openmpi/3.1.4/share/info:${INFOPATH}

ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8