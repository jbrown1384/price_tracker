FROM crystallang/crystal:latest

RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    cmake \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/lexbor/lexbor.git /lexbor \
    && cd /lexbor \
    && cmake . \
    && make install

WORKDIR /app

COPY shard.yml shard.lock* /app/

RUN shards install

COPY . /app

RUN mkdir -p /app/bin /app/data

RUN crystal build src/main.cr --release -o /app/bin/app

EXPOSE 3000

CMD ["/app/bin/app"]