# BUILD
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# TEST
FROM builder AS tester
RUN npm test

# Deploy
FROM node:20-slim AS deploy
WORKDIR /app
COPY package*.json ./

RUN npm install --omit=dev

COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/main.js"]
