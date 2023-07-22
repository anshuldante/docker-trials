# This is an example of a Dockerfile you might see in the wild.
#
# There are lots of keywords in the Dockerfile syntax.  Visit
# https://tinyurl.com/dockerfile-docs to see the latest Dockerfile reference
# documentation. You can also get this Dockerfile and the entrypoint.bash
# script from https://github.com/carlosonunez/linkedin-learning-docker-exercise-files.

# FROM tells Docker which existing Docker image to base your Docker image off
# of. This can be any existing image, local or from the Internet.
#
# By default, Docker will try to get this image from Docker Hub if it is not
# already on your machine.
FROM ubuntu

# Some images will contain a LABEL adding additional data, like the maintainer
# of this image.
LABEL maintainer="Carlos Nunez <dev@carlosnunez.me>"

# USER tells Docker which user to use for any Dockerfile commands underneath it.
# By default, Docker will use the `root` user to execute commands. Since
# most security teams do not like this, the USER keyword is useful in
# changing the user that your app runs as to one that is less powerful.
USER root

# COPY copies files from a directory provided to "docker build" to the container
# image. The directory provided to "docker build" is called the "context."
# The context is usually your working directory, but it does not have to be.
COPY ./entrypoint.bash /

# RUN statements are commands that customize our image. This is a great
# place to install additional software or configure files needed by your application.
# Since our example script needs `curl` and `bash` to run, this Dockerfile
# uses RUN commands to install those programs.
RUN apt -y update
RUN apt -y install curl bash

# This command makes it possible for everyone to execute this script.
RUN chmod 755 /entrypoint.bash

# Here, we're using the USER command to set the default user for containers
# created from this image to the power-less `nobody` user. This ensures that we can't
# break-out of the container and potentially change important files on our
# host.
USER nobody

# Finally, the ENTRYPOINT tells Docker what command containers created from this image
# should run.
#
# You can also use the CMD command to do this, though there are differences.
#
# Consult the documentation shown above to learn more.
ENTRYPOINT [ "/entrypoint.bash" ]
