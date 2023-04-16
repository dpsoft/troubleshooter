FROM  ubuntu:20.04 as builder

RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y build-essential pkg-config clang llvm libcap-dev libelf-dev git && \
    git clone http://github.com/iovisor/bcc/ -b v0.24.0 --recurse-submodules && \
    cd bcc/libbpf-tools && \
    make && mkdir /libbpf-tools && DESTDIR=/libbpf-tools prefix="" make install

FROM  ubuntu:20.04
RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y libelf-dev linux-tools-generic curl git && \
    git clone http://github.com/brendangregg/FlameGraph

COPY --from=builder /libbpf-tools/bin/ /usr/bin/

#Copy the offcpu-profile.sh script to /usr/bin
COPY offcpu-profile.sh /usr/bin/
RUN chmod +x /usr/bin/offcpu-profile.sh