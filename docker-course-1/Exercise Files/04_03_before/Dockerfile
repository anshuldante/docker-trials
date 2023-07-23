# HINT: Remember that you can find `ubuntu` images in the Docker Hub!
FROM ubuntu:xenial

COPY /app.sh /
RUN chmod +x /app.sh

ENTRYPOINT [ "/app.sh" ]
