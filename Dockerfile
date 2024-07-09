FROM ghcr.io/sunnyayyl/flutter-dockerfile@sha256:d5f4389cc07d9b19faeea492af0747e290341877fd55e48a027c1b77a6191762
WORKDIR /project
COPY ./ /project/
CMD ["/project/entrypoint.sh"]