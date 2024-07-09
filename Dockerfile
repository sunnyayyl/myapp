FROM ghcr.io/sunnyayyl/flutter-dockerfile@sha256:f36f1bb639ac9b93ba16aded8c736ef79084e8f639e8dfc0060a700c563f88f9
WORKDIR /project
COPY ./ /project/
CMD ["/project/entrypoint.sh"]