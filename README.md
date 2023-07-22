# Docker Trials

## Docker Gyan

### Containers vs Virtual Machines

| Containers                       | Virtual Machines          |
| -------------------------------- | ------------------------- |
| Run in container runtimes        | run on top of hypervisors |
| Work alongside operating systems | Need hardware emulation   |
| Do not require OS config         | require OS config         |
| Usually run one app at a time    | can run many apps at once |

### Anatomy of a Container

- ![Alt text](docker-course-1/resources/image.png)

#### Different Kernel Namespaces

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

### Advantages of Docker

- Makes configuring and packaging apps and their environments easy.
- Makes sharing images very easy.
- Docker CLI makes application startup easy.

- Podman and CRI are some advantages.
