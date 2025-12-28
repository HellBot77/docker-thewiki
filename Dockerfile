FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/Snaacky/thewiki.git && \
    cd thewiki && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node AS build

WORKDIR /thewiki
COPY --from=base /git/thewiki .
RUN npm install --global retypeapp && \
    retype build

FROM joseluisq/static-web-server

COPY --from=build /thewiki/.retype ./public