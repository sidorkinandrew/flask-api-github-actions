# pull official base image
FROM python:3.10.5-slim-buster

# add flaskapi user
RUN groupadd -r flaskapi && useradd -r -g flaskapi flaskapi

# set working directory
WORKDIR /home/flaskapi

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip install --upgrade pip
COPY ./requirements.txt ./
RUN pip3 install -r ./requirements.txt

# copy project
COPY . .
RUN chown -R flaskapi:flaskapi /home/flaskapi

EXPOSE 8000

# start gunicorn
USER flaskapi
ENTRYPOINT ["sh","./gunicorn_starter.sh"]