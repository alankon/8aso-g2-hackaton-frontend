FROM node:14-alpine as builder
WORKDIR '/app'
COPY ./package.json ./
COPY . .
RUN yarn
RUN yarn build

FROM nginx:alpine

ENV PORT 8080
ENV HOST 0.0.0.0
EXPOSE 8080

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
