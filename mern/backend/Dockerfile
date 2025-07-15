FROM node:23-alpine3.20

WORKDIR /app

COPY package.json package-lock.json /app/

RUN npm install

COPY . /app/

EXPOSE 5050

CMD ["npm", "start"]
