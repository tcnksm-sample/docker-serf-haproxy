Docker + Serf + HAProxy
====

## Setup

### boot2docker

```
$ boot2docker init
$ VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port8080,tcp,,8080,,8080"
$ boot2docker start
```

### Build Haproxy-serf image

```bash
$ cd haproxy
$ docker build -t tcnksm/haproxy .
```

### Build Nginx-serf image

```bash
$ cd web
$ echo '<h1>web1</h1>' > index.html
$ docker build -t tcnksm/web1 .
$ echo '<h1>web2</h1>' > index.html
$ docker build -t tcnksm/web2 .
```

## Run

Run haproxy container

```bash
$ docker run -d -t -p 8080:80 -p 7946 --name proxy tcnksm/haproxy
```

Run web container

```bash
$ docker run -d -t --link proxy:serf tcnksm/web1
$ docker run -d -t --link proxy:serf tcnksm/web2
```

Access it

```bash
$ curl http://0.0.0.0:8080
```

Debug from host 

```bash
$ serf agent -bind 127.0.0.1 -join $(docker port proxy 7946)
$ serf members
```

From OSX, serf can join proxy container, but can not send gossip to another web containers Because they send docker network IP address. This is just membership debugging.




## Reference

- [AUTO-LOADBALANCING DOCKER WITH FIG, HAPROXY AND SERF](http://www.centurylinklabs.com/auto-loadbalancing-with-fig-haproxy-and-serf/)
