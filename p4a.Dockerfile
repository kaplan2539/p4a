ARG BASE=ubuntu:20.04
FROM ${BASE}

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

###############################################################################
# Base install
###############################################################################
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
        build-essential \
        ccache \
        git \
        zlib1g-dev \
        python3 \
        python3-dev \
        python3-pip \
        libncurses5:i386 \
        libstdc++6:i386 \
        zlib1g:i386 \
        openjdk-8-jdk \
        unzip \
        ant \
        autoconf \
        libtool \
        libssl-dev \
        vim \
        tmux \
        wget \
        curl \
        libffi-dev \
        zip \
        pkg-config \
  && apt-get clean \
  && apt-get autoclean
###############################################################################

RUN pip3 install python-for-android cython

ARG SDK_CMDLINE_TOOLS_ARCHIVE=commandlinetools-linux-6514223_latest.zip
ARG SDK_CMDLINE_TOOLS_URL=https://dl.google.com/android/repository/${SDK_CMDLINE_TOOLS_ARCHIVE}
ARG NDK_CMDLINE_TOOLS_ARCHIVE=android-ndk-r19c-linux-x86_64.zip
ARG NDK_CMDLINE_TOOLS_URL=https://dl.google.com/android/repository/${NDK_CMDLINE_TOOLS_ARCHIVE}

ARG ANDROID_SDK=/opt/android-sdk-27
ARG ANDROID_NDK=/opt/android-ndk-r19c

ADD ${SDK_CMDLINE_TOOLS_ARCHIVE} ${ANDROID_SDK}/
ADD ${NDK_CMDLINE_TOOLS_ARCHIVE} /opt/

RUN mkdir -p ${ANDROID_SDK} \
 && cd ${ANDROID_SDK} \ 
 && wget -c ${SDK_CMDLINE_TOOLS_URL} \
 && unzip ${SDK_CMDLINE_TOOLS_ARCHIVE} \
 && rm ${SDK_CMDLINE_TOOLS_ARCHIVE} \
 && yes |${ANDROID_SDK}/tools/bin/sdkmanager --sdk_root=${ANDROID_SDK} "platforms;android-27" \
 && yes |${ANDROID_SDK}/tools/bin/sdkmanager --sdk_root=${ANDROID_SDK} "build-tools;28.0.2"

RUN cd /opt \
 && wget -c ${NDK_CMDLINE_TOOLS_URL} \
 && unzip ${NDK_CMDLINE_TOOLS_ARCHIVE} \
 && rm ${NDK_CMDLINE_TOOLS_ARCHIVE}

ENV ANDROIDSDK ${ANDROID_SDK}
ENV ANDROIDNDK ${ANDROID_NDK}
ENV ANDROIDAPI 27
ENV NDKAPI 21
ENV ANDROIDNDKVER r19c

