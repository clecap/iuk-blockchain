FROM parity/parity:v1.10.4

WORKDIR /
ADD . /

EXPOSE 30300 8540 8180 8450

CMD ["--config", "conf.toml", "--chain", "spec.json"]