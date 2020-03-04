FROM debian:10
ENV LANG=C.UTF-8
RUN apt-get update && apt-get upgrade -y && apt-get install -y zip curl ruby openjdk-11-jre-headless
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.536.sh && \
	chmod +x linux-install-1.10.1.536.sh && \
	./linux-install-1.10.1.536.sh
