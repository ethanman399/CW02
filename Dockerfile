FROM node:latest

RUN mkdir -p /app

WORKDIR /app

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install

COPY server.js server.js

CMD [ "node", "server.js" ]
