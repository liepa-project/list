#########################################################################################
## docker will invoke this file from ../.. dir in order to access code
#########################################################################################
FROM golang:1.21-alpine AS builder

ARG TOOLS_VERSION=0.1

WORKDIR /go/src/
ENV CGO_ENABLED=0

COPY ./src/tools /go/src

RUN go build -o /go/bin/send.metric -ldflags "-X main.version=$TOOLS_VERSION" send.metric/main.go
RUN go build -o /go/bin/fix.segments -ldflags "-X main.version=$TOOLS_VERSION" fix.segments/main.go
#########################################################################################
FROM airenas/list-worker:1.0.400-44fd44b AS cmd_runner
#########################################################################################
FROM python:3.10-bookworm AS res2eaf_code

WORKDIR /tmp
RUN wget https://github.com/liepa-project/res2eaf/archive/refs/heads/master.zip && \
    unzip master.zip 

#########################################################################################
FROM python:3.10-bookworm AS runner

ARG BUILD_VERSION=0.1

LABEL org.opencontainers.image.version=$BUILD_VERSION \
      org.opencontainers.image.authors="mindaugas.greibus@gmail.com" \
      name="res2eaf-service" \
      maintainer="mindaugas.greibus@gmail.com" \
      vendor="mindaugas.greibus@gmail.com" \
      version=$BUILD_VERSION \
      release=$BUILD_VERSION \
      summary="This image is used to start the LiST res2eaf worker service" \
      description="This image is used to start the LiST res2eaf worker service" 

RUN apt-get update && apt-get install -y \
      build-essential \
      libsndfile1 \
      && rm -rf /var/cache/apt/archives /var/lib/apt/lists



VOLUME ["/data"]
VOLUME ["/models"]
WORKDIR /app

#COPY src/decode/res2eaf/python/requirements.txt /cmd/python/
COPY --from=res2eaf_code /tmp/res2eaf-master/requirements.txt /cmd/python/
RUN pip install --no-cache-dir -r /cmd/python/requirements.txt \
      && rm -rf /root/.cache

COPY --from=cmd_runner /app/cmdWorkerService /app/
COPY --from=builder /go/bin/send.metric /app/
COPY --from=builder /go/bin/fix.segments /app/
COPY build/res2eaf/config.yaml /app/
COPY src/decode/scripts/*sh /app/
#COPY src/decode/res2eaf/python/scripts/*.py /app/scripts/
COPY --from=res2eaf_code /tmp/res2eaf-master/* /app/scripts/

COPY build/res2eaf/Makefile.options /cmd/
COPY src/decode/res2eaf/Makefile /cmd/

ENV LD_LIBRARY_PATH=/usr/local/lib/python3.10/site-packages/nvidia/cublas/lib:/usr/local/lib/python3.10/site-packages/nvidia/cudnn/lib

ENTRYPOINT ["./cmdWorkerService"]
