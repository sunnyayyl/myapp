FROM alpine:latest
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:latest $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"
WORKDIR /
RUN apk update
RUN apk add git curl unzip xz zip glu
RUN git clone https://github.com/flutter/flutter.git flutter
ENV PATH="$PATH:/flutter/bin"
RUN flutter channel stable
RUN yes | flutter doctor --android-licenses
WORKDIR /project
COPY * /project/
CMD ["/project/entrypoint.sh"]