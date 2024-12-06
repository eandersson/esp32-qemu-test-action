FROM espressif/idf:v5.3.2

ARG DEBIAN_FRONTEND=nointeractive

RUN apt-get update \
  && apt install -y -q \
  cmake \
  git \
  libglib2.0-0 \
  libnuma1 \
  libpixman-1-0 \
  ruby

# QEMU
ENV QEMU_REL=esp-develop-9.0.0-20240606
ENV QEMU_DIST=qemu-esp_develop_9.0.0_20240606-src.tar.xz
ENV QEMU_URL=https://github.com/espressif/qemu/releases/download/${QEMU_REL}/${QEMU_DIST}

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV IDF_PYTHON_ENV_PATH=/opt/esp/python_env/idf5.3_py3.10_env

RUN wget --no-verbose ${QEMU_URL} \
  && tar -xf $QEMU_DIST -C /opt \
  && rm ${QEMU_DIST}

ENV UNITY_REL=v2.6.0
ENV UNITY_DIST=${UNITY_REL}.tar.gz
ENV UNITY_URL=https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/${UNITY_DIST}

RUN wget --no-verbose ${UNITY_URL} \
  && tar -xf ${UNITY_DIST} -C /opt \
  && rm ${UNITY_DIST}

ENV PATH=/opt/qemu/bin:${PATH}

RUN echo $($IDF_PATH/tools/idf_tools.py export) >> $HOME/.bashrc

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
