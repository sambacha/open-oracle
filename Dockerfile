FROM node:14.5.0-alpine3.10
RUN apk add --update --no-cache nodejs

ADD package.json yarn.lock /tmp/
ADD .yarn-cache.tgz /


WORKDIR /open-oracle
RUN wget https://github.com/ethereum/solidity/releases/download/v0.6.10/solc-static-linux -O /usr/local/bin/solc && chmod +x /usr/local/bin/solc
RUN apk update && apk add --no-cache --virtual .gyp \
    python \
    make \
    g++ \
    yarn \
    nodejs \
    git

RUN yarn global add node-gyp npx


RUN cd /tmp && yarn
RUN mkdir -p /service && cd /open-oracle/ && ln -s /tmp/node_modules


ENV PROVIDER PROVIDER
COPY . /service

WORKDIR /service
ENV FORCE_COLOR=1

EXPOSE 8080
ENTRYPOINT ["npm"]
CMD ["npx saddle"]
