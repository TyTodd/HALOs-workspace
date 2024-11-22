# Use NVIDIA’s official CUDA 12.1 base image
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# Set environment variables for CUDA
ENV PATH="/usr/local/cuda-12.1/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/local/cuda-12.1/lib64:${LD_LIBRARY_PATH}"

# Install system utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    sudo \
    unzip \
    htop \
    nano \
    vim \
    build-essential \
    ca-certificates \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Update PATH for Conda
ENV PATH="/opt/conda/bin:${PATH}"

# Create a new conda environment named "halos" with Python 3.10.14
# RUN conda create -n halos python=3.10.14 && \
#     conda init bash && \
#     echo "conda activate halos" >> ~/.bashrc

# Install commonly used Python packages in the "halos" environment
# RUN /opt/conda/bin/conda install -n halos -y \
#     numpy \
#     scipy \
#     pandas \
#     matplotlib \
#     scikit-learn \
#     seaborn \
#     jupyter \
#     ipython \
#     tqdm \
#     requests \
#     pip \
#     && conda clean -afy

# Install PyTorch with CUDA 12.1 support
# RUN /opt/conda/bin/conda install -n halos -c pytorch -c nvidia \
#     pytorch=2.2.0 \
#     torchvision=0.15.2 \
#     torchaudio=2.2.0 \
#     cudatoolkit=12.1 \
#     && conda clean -afy

# Optional: Install other popular packages in the "halos" environment
# RUN /opt/conda/bin/conda install -n halos -c conda-forge \
#     opencv \
#     flask \
#     fastapi \
#     && conda clean -afy

# Install pip packages like transformers and accelerate
# RUN /opt/conda/envs/halos/bin/pip install transformers accelerate

# Replace 1000 with the actual UID and GID for tytodd
ARG USER_ID=21542
ARG GROUP_ID=2000

# Create a new user with the same UID and GID as tytodd
RUN groupadd -g ${GROUP_ID} tytodd && \
    useradd -m -u ${USER_ID} -g tytodd -s /bin/bash tytodd && \
    chown -R tytodd:tytodd /home

# Switch to the new user
USER tytodd

SHELL ["/bin/bash", "--login", "-c"]
CMD ["bash", "-c", "tail -f /dev/null"]
