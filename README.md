# Docker Trials

## Docker

### Basics

#### Containers vs Virtual Machines

| Containers                       | Virtual Machines          |
| -------------------------------- | ------------------------- |
| Run in container runtimes        | run on top of hypervisors |
| Work alongside operating systems | Need hardware emulation   |
| Do not require OS config         | require OS config         |
| Usually run one app at a time    | can run many apps at once |

#### Anatomy of a Container

- ![Alt text](resources/image.png)

##### Different Kernel Namespaces

| Name   | Description                |
| ------ | -------------------------- |
| USERNS | User Lists                 |
| MOUNT  | Access to file systems     |
| NET    | Network communication      |
| IPC    | Interprocess communication |
| TIME   | Ability to change time     |
| PID    | Process ID management      |
| CGROUP | Create control groups      |
| UTS    | Create host/domain names   |

- Docker containers do not support the TIME namespace.
- Docker uses Control groups for
  - Monitor and restrict CPU usage
  - Monitor and restrict network and disk bandwidth
  - Monitor and restrict memory consumption
  - Does not support Assign disk quotas

- Natively only runs on Linux, some newer versions of Windows are also supported.
- Container images are bound to their parent operating systems.

#### Advantages of Docker

- Makes configuring and packaging apps and their environments easy.
- Makes sharing images very easy.
- Docker CLI makes application startup easy.

- Podman and CRI are some advantages.

### Using Docker

#### Docker Best Practices

- Use verified images. They're simply more secure.
  - Can also use free image scanners like Clair, Trivy, and Dagda.
- Created proper numbered tags instead of using "latest".
- Use non-root users.

#### Docker CLI

```sh
# Docker CLI help
docker --help
docker pull --help

# Creating a container
docker container create hello-world:linux

# list containers
# Only shows running containers
docker ps
# Shows all containers
docker ps -a

# start container
docker container start <first-x-chars-of-container-id>

# see logs
docker logs <first-x-chars-of-container-id>

# attach the container to the application
docker container start <first-x-chars-of-container-id> --attach

# docker run = container create, container start, container attach.
docker run hello-world:linux

# builds an image from a docker file
docker build -t my-first-image .
docker build -f server.Dockerfile . --tag first-server

# -d to not attach the terminal to the application
docker run -d first-server

# execute commands in the container
docker run -d first-server
docker exec --interactive --tty db0 bash

# stop applications
docker stop db0
# Force stop
docker stop -t 0 db0

# remove containers
docker rm af6
# remove containers that are running i.e. stop and delete
docker rm -f
# remove all containers
docker ps -aq | xargs docker rm

# list images
docker images
# remove images
docker rmi first-server abcd askjgdakshd

# run with name
docker run -d --name web-server web-server
docker logs web-server

# run with port mapping
docker run -d --name web-server -p 5001:5000 web-server

# login to docker
docker login
# rename an image
docker tag web-server anshul98/web-server:0.0.1

# clean up a bunch of space in the docker VM
docker system  prune

# container performance snapshot
docker stats
# runs the container to sleep infinitely
docker run --name alpine --entrypoint=sleep -d alpine infinity
# runs an interactive tty shell on the container
docker exec -i -t alpine sh

# shows what's happening in a container
docker top alpine
# shows a bunch of details about the container
docker inspect alpine

# last exercise
docker build . --tag xen
docker stats xen # to check the usage
docker top xen # to look for culprits killing the container
docker run -it --name xen xen # for an interactive shell
```

#### Docker File

- FROM: the base image. Docker will pull it from docker hub if it's not already there locally.
- LABEL: various tagging properties.
- USER: the user to use for commands execution
- COPY: copies stuff from a local directory to the image. The directory provided to docker is called the context and is the execution dir by default, but it can be changed.
- RUN: commands to customize the image.
- ENTRYPOINT: defines the entry point of the docker image.
- CMD: defines the default args for ENTRYPOINT.

#### Saving Data from Containers

```sh
# create a file in the container via shell and save it into the machine using volume mounting
docker run --rm --entrypoint sh -v /tmp/container:/tmp ubuntu -c "echo 'hello there.' > /tmp/file && cat /tmp/file"

# running an nginx server
docker run --name website -p 8080:80 -v "$PWD/website:/usr/share/nginx/html" --rm nginx
```

## Docker Compose

### Compose Basics

| Docker (procedural)                          | Compose (declarative)                             |
| -------------------------------------------- | ------------------------------------------------- |
| Series of ordered steps                      | specify end results                               |
| Based on assumptions about the previous step | System will determine which steps to execute next |
| Easy to introduce errors                     | Produces the same results every time.             |

- Config files allow for easy version control
- Self documenting
- Easier management

| Designed for               | Not designed for                                      |
| -------------------------- | ----------------------------------------------------- |
| Local development          | Distributed systems.                                  |
| staging server             | No tools for running containers across multiple hosts |
| Continuous integration env | Complex prod envs                                     |

### Samples

```yaml
version: "20.10.17"

services:
  storefront: 
    build: .
  database: 
    image: "mysql"
```

```sh
# Build images, create containers and start them (a combination of build, create, and start)
docker-compose up

# Stop containers, delete containers and images, and remove all artifacts (a combination of stop and rm)
docker-compose down

## restart containers
docker-compose restart (a combination of stop and start)
```

- Environment variables
  - Accessible inside the running docker container
  - These are useful for
    - Logger.log("logging from env: {runtime_env}");
    - If (runtime_env == test) disable_payments();
    - Could practically be used for anything.
  - Leaving the value part out in the config imports the variable value from the host that the containers are running on.
  - Use environment files if the list of variables is too long.
- Build arguments
  - Accessible only at build time
  - These are useful for
    - Build tool versions
    - Cloud platform config

```yaml
version: "20.10.17"

services:
  storefront:
    build:
      context: .
      args:
        - region=us-east-1
        - anshul=0
    environment:
      - runtime_env=dev
  database: 
    image: "mysql"
    env_file:
      - ./mysql/env_vars
```

### Mounting Volumes

- Target: the target directory for the container's data (inside the container).
- Source: the source directory from the host. If not defined, DC creates one.
- Access mode: the default is rw, but we can override it to ro if applicable.
- Named volumes: allows docker-compose up to copy data from the old volume to the new one by default. `docker-compose down --volumes` deletes any named volumes.

```yaml
    volumes:
      - ./mysql:/var/lib/mysql:rw # source:target:mode
volumes:
  kineteco:
```

```yaml
# long syntax for named volume
type: volume
source: kineteco
target: /var/lib/mysql
read_only: false
```

### Exposing Ports

```yaml
services:
  scheduler:
    build: scheduler/.
    ports:
      - "81:80"
  storefront: 
    build: storefront/.
    ports:
      - "80:80"
      - "443:443"
  database: 
    image: "mysql"
    env_file:
      - ./mysql/env_vars
    volumes:
      - ./mysql:/docker-entrypoint-initdb.d:ro
      - kineteco:/var/lib/mysql
volumes:
  kineteco: 
```

### Enforcing Startup Order

- We may need some of the services to be started before the others, and startup order helps with that.

```yaml
  scheduler:
    build: scheduler/.
    ports:
      - "81:80"
  storefront: 
    build: storefront/.
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - database
  database: 
    image: "mysql"
    env_file:
      - ./mysql/env_vars
    volumes:
      - ./mysql:/docker-entrypoint-initdb.d:ro
      - kineteco:/var/lib/mysql
volumes:
  kineteco: 
```

## Dynamic Config

- Start all services within a profile using `docker-compose --profile store_services up`
- The syntax works with all compose commands.

```yaml
    profiles:
      - scheduling_services
```

- We generally want the same compose file for related services but there can be use case to have different ones too.
  - Distinct desired behaviors that do not coincide.
  - Different envs (testing vs staging)
  - Not a good idea to have different files for different components of a single system.
- Docker compose reads 2 config files by default docker-compose.yaml and docker-compose.override.yaml. Here are the merge rules for them:
  - Array fields will append the override values and single value properties will have their values overridden.
  - Override files can be partial or incomplete.
  - We can also have a bunch of override files and the can be run by using `docker-compose -f docker-compose.yaml -f docker-compose.local.yaml up`
- We can use env variables from the host by using $ like `image: "mysql:${TAG}"`.
  - If the variable is not set, docker will default to an empty string.
  - Inline in docker-compose config
  - In .env file: reads by default. If it's not in the same directory, we can pass it using: `docker-compose --env-file [path]`
  - Throw error if missing (no default)
- A variable in the host will override the default.
