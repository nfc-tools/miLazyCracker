FROM kalilinux/kali-rolling
ARG REPO=https://github.com/orensbruli/miLazyCracker
RUN apt update && apt install wget sudo make autoconf pkg-config gcc git mfcuk xz-utils  -y
RUN git clone $REPO
RUN cd miLazyCracker && bash -x miLazyCrackerFreshInstall.sh
ENTRYPOINT ["miLazyCracker"]

