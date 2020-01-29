FROM alpine:edge

RUN apk update
RUN apk add git patchelf brotli unzip p7zip zip curl wget gnupg python3 python3-dev bash moreutils openssh openssl 	ca-certificates --no-cache
RUN pip3 install requests pyYaml
RUN echo "ci ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN adduser --home /home/ci -S ci
RUN mkdir /app
RUN chown -R ci /app
RUN chmod -R 777 /app
USER ci

WORKDIR /app
COPY runner.sh /app
COPY get_rom.py /app

CMD bash runner.sh | ts '[%Y-%m-%d %H:%M:%S]'
