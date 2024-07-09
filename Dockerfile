FROM alpine:latest
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:latest $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"
WORKDIR /
RUN apk update
RUN apk add git curl unzip xz zip glu bash gcompat
RUN git clone https://github.com/flutter/flutter.git flutter --depth 1 -b stable
ENV PATH="$PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin"
RUN flutter doctor
RUN yes | flutter doctor --android-licenses
WORKDIR /project
COPY ./ /project/
CMD ["/project/entrypoint.sh"]