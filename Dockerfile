FROM ubuntu:19.10

RUN apt-get update && apt-get install -y gcc libc6-dev zlib1g-dev make libmysqlclient-dev mysql-client

ADD . /tpcc-mysql
ENV PATH /tpcc-mysql:$PATH
WORKDIR /tpcc-mysql
RUN cd src && make

COPY run.sh /run.sh

ENTRYPOINT ["sh", "/run.sh"]
