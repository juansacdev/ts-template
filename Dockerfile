# Stage 1: Building the code
FROM node:20-alpine3.11 as builder

WORKDIR /usr/app

COPY package*.json ./

COPY tsconfig.json ./

RUN npm ci --silence

COPY . .

RUN npm run build

# Stage 2: Running the code
FROM node:20-alpine3.11

WORKDIR /usr/app

COPY --from=builder /usr/app/package.json ./package.json

COPY --from=builder /usr/app/package-lock.json ./package-lock.json

COPY --from=builder /usr/app/build .

RUN npm ci --production

RUN chown -R node:node /usr/app

USER node

EXPOSE 3000

CMD [ "npm", "start"]
