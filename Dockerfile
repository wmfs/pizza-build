 # First build
FROM wmfs/node:lts-alpine AS build
ARG NPM_TOKEN
COPY package.json ./
COPY ./config/. ./config/.
RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > .npmrc && \
    npm install --production && \
    rm -f .npmrc
# Second build
FROM wmfs/node:lts-alpine
COPY --from=build . .
RUN apk add --no-cache tzdata
ENV TZ=Europe/London
USER node
CMD ["node", "./node_modules/@wmfs/tymly-runner/lib/index.js"]
