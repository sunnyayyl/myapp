FROM ghcr.io/sunnyayyl/flutter-dockerfile@sha256:ba8bc6cc682ba73c186846e2c0d6ebddf76ff746a2154eec88a9456930c350ed
WORKDIR /project
COPY ./ /project/
CMD ["/project/entrypoint.sh"]