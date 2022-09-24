FROM node:14-alpine as builder
WORKDIR '/app'
COPY ./package.json ./
COPY . .

ARG BACKEND_URL
ENV BACKEND_URL BACKEND_URL

RUN yarn
RUN yarn build

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/configfile.template

ENV PORT 8080
ENV HOST 0.0.0.0
EXPOSE 8080

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

CMD sh -c "envsubst '\$PORT' '\$BACKEND_URL' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"
