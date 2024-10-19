#FROM airenas/ubuntu.make:2.0
#LABEL Description="This image is used to host the LiST transcription worker service" \ 
#      Maintainer="airenass@gmail.com" Vendor="Airenas Vaiciunas" Version="2.0" 
FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04
WORKDIR /root
RUN apt-get update -y && apt-get install -y python3-pip
RUN pip3 install faster-whisper
#CMD ["python3", "infer.py"]

#ENTRYPOINT ["./infer.py"]


VOLUME ["/data"]
VOLUME ["/apps"]
VOLUME ["/models"]
WORKDIR /app

#COPY transciption/whisper.py  /apps/whisper/
COPY deploy/cmdWorkerService /app/
COPY config.yaml /app/
COPY deploy/pipe.runner /app/
COPY deploy/send.metric /app/
COPY deploy/*.sh /app/

COPY deploy/cmd/Makefile /cmd/
COPY Makefile.options /cmd/

ENTRYPOINT ["./cmdWorkerService"]
