FROM node:20 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install --frozen-lockfile

COPY . .

RUN npm run build

FROM node:20-slim AS production

WORKDIR /app

COPY --from=build /app/package*.json ./
COPY --from=build /app/dist /app/dist

RUN npm install --production --frozen-lockfile

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

CMD ["node", "dist/app.js"]

FROM node:20-slim AS development

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

ENV NODE_ENV=development
ENV PORT=3000

EXPOSE 3000

CMD ["npx", "nodemon", "src/app.js"]




