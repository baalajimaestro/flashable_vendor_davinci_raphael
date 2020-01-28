FROM debian:buster-slim

RUN apt install patchelf brotli unzip p7zip-full zip curl wget gpg python python-kerberos python3 python3-pip sudo -y
RUN sudo pip3 install requests pyYaml
RUN sudo echo "ci ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd -m -d /home/ci ci
RUN useradd -g ci wheel
RUN mkdir /app
RUN chown -R ci /app
RUN chmod -R 777 /app
USER ci

WORKdIR /app
COPY runner.sh /app

CMD bash runner.sh | ts '[%Y-%m-%d %H:%M:%S]'
