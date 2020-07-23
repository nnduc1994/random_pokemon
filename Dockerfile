FROM node:12 AS build
WORKDIR /usr/src/app

#install dependencies
COPY package*.json ./
RUN npm install

COPY src /usr/src/app/src
RUN npm run build

RUN npm prune --production

FROM node:alpine
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package*.json ./

ARG PORT=8080
ENV PORT=${PORT}
EXPOSE ${PORT}
CMD ["npm", "start"]



