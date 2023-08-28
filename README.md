## Intro
Taken from [FireHOL](https://github.com/firehol/blocklist-ipsets/wiki).  
Dockerized version of `update-ipsets` script.  
Original version is [here](https://raw.githubusercontent.com/firehol/firehol/master/sbin/update-ipsets)  

## Info
This is a customi[s|z]ed version, to solve some of our needs:  
- download lists not implemented in original script
- write a `rbl` file used by [`rbldnsd`](https://github.com/Neomediatech/rbldns)
- run as container
- run as [pseudo]service to fire up every X time

## Usage
You can run this container with this command:  
`docker run -d --name update-ipsets --hostname update-ipsets -v /host/path:/data neomediatech/update-ipsets`  
or  
`docker run -it --name update-ipsets --hostname update-ipsets -v /host/path:/data neomediatech/update-ipsets`  
It will run every 10 mins (by default) or every seconds you set by `SLEEP` env var.  

For example:  
`docker run -d --name update-ipsets --hostname update-ipsets -e SLEEP=300 -v /host/path:/data neomediatech/update-ipsets`  
It runs every 5 minutes.  

Logs are written to stdout.  

While the container is running you can enable a list by running the command:  
`docker exec -it update-ipsets update-ipsets enable list_name_you_want_to_enable`  
It will be enabled automagically after the next awake (by default 600 seconds).

If you want to delete obsolete ipset run:  
`docker exec -it update-ipsets update-ipsets --cleanup`  

## VERY IMPORTANT!
Because ipsets are written into the kernel and Docker shares the kernel with the host, you have to run the same OS version between host and container, or at least the same `ipset` version.  
Running this container with docker swarm/compose can be tricky if you want to make ipset works. For now it doesn't work, but it's not a problem because I'm running it as a standalone container.  

### Docker swarm/compose
If you want to run as a stack or with compose:  
Create the file `docker-compose.yml` (or the name you prefer) and put inside it:  
```
version: '3.8'

services:
  app:
    image: neomediatech/update-ipsets:latest
    hostname: update-ipsets
    volumes:
      - data:/data
    environment:
      SLEEP: ${SLEEP:-600}
      ENV_IPSETS_APPLY: ${ENV_IPSETS_APPLY:-0}
    #cap_add:
    #  - NET_ADMIN

volumes:
  data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /folder/path/in/your/host

```
Then run:  
`docker stack deploy -c docker-compose.yml update-ipsets`  
or  
`docker compose -f docker-compose.yml up update-ipsets` (with `-d` after `up` to run it in background)  
Remember to change the path for the volume (`device: /folder/path/in/your/host`) and to enable NET_ADMIN if you want to make `ipset` works (delete the `#` on cap_add and NET_ADMIN lines).  

### Variables

These variables can be passed to the container from docker-compose.yml or directly by command line:

| Variable         | Default | Description                                                   |
| ---------------- | ------- | ------------------------------------------------------------- |
| SLEEP            | 600     | How many seconds to wait before running the next update       |
| ENV_IPSETS_APPLY | 0       | Enables or disables the automatic ipsets update in the kernel |
| ENV_CONFIGFILE   | empty   | Alternative path for the configuration file                   |

In `/data/ipsets/ipsets.d` folder you can put your own download list logic, for example see [HERE](ipsets.d/)  

Other default settings can be found on [original repo](https://github.com/firehol/blocklist-ipsets/wiki/Downloading-IP-Lists).  
### Default settings
- By deafult ipsets are NOT applied to the kernel (`IPSETS_APPLY = 0`), if you need it set `ENV_IPSETS_APPLY = 1`. The container must be run with `--cap-add=NET_ADMIN` setting
- `/data/ipsets/ipsets.d` folder is used for your own download list logic
- Web folder is placed in `/data/ipsets/web`
- BASE_DIR is in /data/ipsets

## To Do
- [ ] Write results in log file (useful?)

