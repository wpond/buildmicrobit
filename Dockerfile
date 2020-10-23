FROM centos:7

RUN yum install -y bzip2 make

COPY 3rdparty /3rdparty

# GNU toolchain linux x86_64
# https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
RUN mkdir /input /output /workdir /workdir/3rdparty && cd /workdir/3rdparty && tar -xvjf /3rdparty/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2

ENV PATH="/workdir/3rdparty/gcc-arm-none-eabi-9-2020-q2-update/bin:${PATH}"

COPY include /workdir/include
copy toolchain /workdir/toolchain
COPY Makefile /workdir/Makefile

WORKDIR /workdir

RUN make CS= init

CMD make
