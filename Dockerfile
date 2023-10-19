# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY ./UniqueNet/package*.json ./
RUN npm install
COPY ./UniqueNet .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY --from=build-stage /app/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]