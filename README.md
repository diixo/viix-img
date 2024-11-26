# aiveex-img

Source: https://github.com/phusion/baseimage-docker
Source: https://registry.hub.docker.com/r/phusion/baseimage/
Source: https://github.com/phusion/baseimage-docker/releases?page=3

https://hub.docker.com/r/phusion/baseimage/tags

Dockerfile.txt is sge Dockerfile

## build

```
docker build -f image/Dockerfile -t viix:22.04 .
```

# build and run
```
docker build -f image/Dockerfile -t viix:22.04 . && docker run -d --name viix-container viix:22.04
```

### What are the problems with the stock Ubuntu base image?

Ubuntu is not designed to be run inside Docker. Its init system, Upstart, assumes that it's running on either real hardware or virtualized hardware, but not inside a Docker container. But inside a container you don't want a full system anyway, you want a minimal system. But configuring that minimal system for use within a container has many strange corner cases that are hard to get right if you are not intimately familiar with the Unix system model. This can cause a lot of strange problems.

Baseimage-docker gets everything right. The "Contents" section describes all the things that it modifies.


### Why use baseimage-docker?
You can configure the stock ubuntu image yourself from your Dockerfile, so why bother using baseimage-docker?

Configuring the base system for Docker-friendliness is no easy task. As stated before, there are many corner cases. By the time that you've gotten all that right, you've reinvented baseimage-docker. Using baseimage-docker will save you from this effort.
It sets up the base system correctly. Many people may not think so, but Unix has many corner cases caused by decades of cruft. Getting them wrong can result in very strange problems. This image does everything correctly. Learn more.⁠
It reduces the time needed to run docker build, allowing you to iterate your Dockerfile more quickly.
It reduces download time during redeploys. Docker only needs to download the base image once: during the first deploy. On every subsequent deploys, only the changes you make on top of the base image are downloaded.
