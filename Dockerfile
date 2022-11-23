####
# Build image
####
FROM --platform=linux/arm64 ghcr.io/graalvm/graalvm-ce:ol9-java17 AS build
LABEL maintainer avvero

WORKDIR /app
ADD http://more.musl.cc/10/x86_64-linux-musl/x86_64-linux-musl-native.tgz x86_64-linux-musl-native.tgz
RUN tar zxvf x86_64-linux-musl-native.tgz
ENV TOOLCHAIN_DIR=/app/x86_64-linux-musl-native
RUN echo $TOOLCHAIN_DIR
ENV CC=$TOOLCHAIN_DIR/bin/gcc
ADD https://zlib.net/zlib-1.2.13.tar.gz zlib-1.2.13.tar.gz
RUN tar zxvf zlib-1.2.13.tar.gz
WORKDIR /app/zlib-1.2.13
RUN ./configure --prefix=$TOOLCHAIN_DIR --static
RUN make
RUN make install
WORKDIR /app
ENV PATH=$PATH:$TOOLCHAIN_DIR/bin
RUN echo $TOOLCHAIN_DIR
RUN ls -al $TOOLCHAIN_DIR/bin
RUN ls -al $TOOLCHAIN_DIR
COPY . .
RUN ls -al
RUN ls -al /app/x86_64-linux-musl-native/bin
RUN ./gradlew nativeCompile

####
# Runtime image
####
FROM scratch
LABEL maintainer avvero

COPY --from=build /app/build/native/nativeCompile/demo /app/demo

ENTRYPOINT [ "/app/demo" ]
