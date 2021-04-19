[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/5325)
# singularity-quda-hip
Singularity recipe allowing to set up an enviroment where [QUDA](https://github.com/lattice/quda/tree/feature/hip-compile-fixes) can be built. Currently supports [Scientific Linux 7](https://hub.docker.com/r/scientificlinux/sl) systems.
### Build the container
To build the container as a sandbox run

    sudo singularity build --sandbox AMD.sandbox Singularity

As an alternative (recommended) , clone the sif image from [Singularity-hub](https://singularity-hub.org/collections/5325) and convert the image to sandbox 

    sudo singularity build --sandbox AMD.sandbox singularity-quda-hip.sif

### Build QUDA

Edit the Sandbox with

    sudo singularity shell --writable AMD.sandbox

The folder `/workdir` contains the QUDA repository. The script `install_quda.sh`, contains the cmake setup allowing to build the library. 
Please refer to [the QUDA repo](https://github.com/lattice/quda/blob/feature/hip-compile-fixes/HIP_NOTES.md).

### Run the test executables

Transfer the sif image to the HPC facility and run a Slurm job to convert the sif image back into a sandbox. 
At this stage, the setup is ready and the QUDA executable can be executed from the sandbox with a Slurm job.
