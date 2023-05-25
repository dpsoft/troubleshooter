FROM  ubuntu:22.04 as builder

RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y build-essential pkg-config clang llvm libcap-dev libelf-dev git && \
    git clone https://github.com/iovisor/bcc/ -b v0.25.0 --recurse-submodules && \
    cd bcc/libbpf-tools && \
    make && mkdir /libbpf-tools && DESTDIR=/libbpf-tools prefix="" make install

FROM  ubuntu:22.04
RUN set -ex; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update && \
    apt-get install -y libelf-dev linux-tools-generic curl git && \
    git clone https://github.com/brendangregg/FlameGraph

COPY --from=builder /libbpf-tools/bin/ /usr/bin/