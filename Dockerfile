FROM baalajimaestro/android_build:latest

RUN sudo echo "ci ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN useradd -m -d /home/ci ci
RUN useradd -g ci wheel
RUN mkdir /app
RUN chown -R ci /app
RUN chmod -R 777 /app
USER ci

WORKdIR /app
COPY runner.sh /app
COPY get_rom.py /app

CMD bash runner.sh | ts '[%Y-%m-%d %H:%M:%S]'
