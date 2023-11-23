FROM nvidia/cuda:11.0.3-devel-ubuntu18.04

WORKDIR /

RUN mkdir /workspace

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND noninteractive\
    SHELL=/bin/bash

# Update and install necessary packages
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends\
    git\
    wget\
    curl\
    bash\
    software-properties-common\
    openssh-server

# Add Python 3.7 repository
RUN add-apt-repository ppa:deadsnakes/ppa

# Install Python 3.7 and create necessary symlinks
RUN apt-get update && \
    apt install python3.7 -y --no-install-recommends && \
    ln -s /usr/bin/python3.7 /usr/bin/python && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.7 /usr/bin/python3

# Install libpython3.7-stdlib for distutils
RUN apt-get install -y libpython3.7-stdlib && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py

# Install PyTorch and other Python packages
RUN pip install --no-cache-dir torch torchvision torchaudio -f https://download.pytorch.org/whl/cu113/torch_stable.html
RUN pip install --no-cache-dir -U jupyterlab ipywidgets jupyter-archive
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# Add and configure start script
ADD start.sh /
RUN chmod +x /start.sh

CMD [ "/start.sh" ]
