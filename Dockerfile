FROM alpine:latest
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:latest $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"
WORKDIR /
COPY ./assert_checksum.bash /
RUN apk update
RUN apk add git curl unzip xz zip glu bash gcompat
RUN curl --output commandlinetools-linux.zip "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip"
RUN ./assert_checksum 2d2d50857e4eb553af5a6dc3ad507a17adf43d115264b1afc116f95c92e5e258 commandlinetools-linux.zip
RUN mkdir android_sdk
RUN unzip commandlinetools-linux.zip -d android_sdk
ENV ANDROID_HOME="/android_sdk"
RUN git clone https://github.com/flutter/flutter.git flutter --depth 1 -b stable
ENV PATH="$PATH:/flutter/bin:/flutter/bin/cache/dart-sdk/bin:/android_sdk/bin"
RUN flutter doctor
RUN yes | flutter doctor --android-licenses
WORKDIR /project
COPY ./ /project/
CMD ["/project/entrypoint.sh"]