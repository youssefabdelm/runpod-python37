FROM nvidia/cuda:11.3-runtime-ubuntu18.04

WORKDIR /

RUN mkdir /workspace

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV DEBIAN_FRONTEND noninteractive\
    SHELL=/bin/bash
RUN apt-get update --yes && \
    apt-get upgrade --yes && \
    apt install --yes --no-install-recommends\
    git\
    wget\
    curl\
    bash\
    software-properties-common\
    openssh-server
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install python3.7 -y --no-install-recommends && \
	ln -s /usr/bin/python3.7 /usr/bin/python && \
	rm /usr/bin/python3 && \
	ln -s /usr/bin/python3.7 /usr/bin/python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py
# Update the PyTorch installation line to match CUDA 11.3 compatibility
RUN pip install --no-cache-dir torch torchvision torchaudio -f https://download.pytorch.org/whl/cu113/torch_stable.html
RUN pip install --no-cache-dir -U jupyterlab ipywidgets jupyter-archive
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

ADD start.sh /

RUN chmod +x /start.sh

CMD [ "/start.sh" ]
