FROM maven:3-eclipse-temurin-8

LABEL org.opencontainers.image.authors="Certseeds <51754303+Certseeds@users.noreply.github.com>" \
    org.opencontainers.image.source="https://github.com/Certseeds/dotfiles" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.description="jdk8 with maven-cn source"

COPY ./settings.xml /root/.m2/settings.xml

