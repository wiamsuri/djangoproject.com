
FROM python:3.5.7-alpine


WORKDIR /usr/src/app


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1


RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add postgresql-dev \
    && pip install psycopg2 \
    && apk del build-deps


RUN apk add --update nodejs nodejs-npm


RUN apk add build-base python-dev py-pip jpeg-dev zlib-dev
ENV LIBRARY_PATH=/lib:/usr/lib


RUN apk --update add postgresql-client


RUN apk add git


RUN pip install --upgrade pip
COPY ./requirements ./requirements
RUN pip install -r ./requirements/dev.txt
RUN pip install -r ./requirements/tests.txt
RUN pip install tox
RUN npm install


COPY ./docker-entrypoint.sh ./docker-entrypoint.sh


COPY . .


ENTRYPOINT ["./docker-entrypoint.sh"]
