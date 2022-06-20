# flask-api

## Prerequisites
- install [latest Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- install [latest Docker-compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)

## To run this simple REST Flask API
- git clone [this repository](https://github.com/sidorkinandrew/flask-api.git)

```bash
git clone https://github.com/sidorkinandrew/flask-api.git && cd flask-api
```

- run docker-compose to build the flask_api image and create the services

```bash
docker-compose up -d
```

- use the generated Swagger 2.0 endpoint to excercise the provided REST API

```bash
[localhost or hostname]/api
```

