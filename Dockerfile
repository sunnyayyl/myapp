FROM ghcr.io/sunnyayyl/flutter-dockerfile@sha256:f422fa92bffb3a490d4af887dfe75bffecef5042586d0e0bd473d7330a8a61af
WORKDIR /project
COPY ./ /project/
CMD ["/project/entrypoint.sh"]