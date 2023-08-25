## Intro
Taken from [FireHOL](https://github.com/firehol/blocklist-ipsets/wiki).  
Dockerized version of `update-ipset` script.  
Original version is [here](https://raw.githubusercontent.com/firehol/firehol/master/sbin/update-ipsets)  

## Info
This is a customi[s|z]ed version, to solve some of our needs:  
- download lists not implemented in original script
- write a `rbl` file used by [`rbldnsd`](https://github.com/Neomediatech/rbldns)
- run as container
- run as [pseudo]service to fire up every X time

## Usage
You can run this container with this command:  
`docker run -d --name update-ipset --hostname update-ipset -v /host/path:/data neomediatech/update-ipset`  
or  
`docker run -it --name update-ipset --hostname update-ipset -v /host/path:/data neomediatech/update-ipset`  
It will run every 10 mins (by default) or every seconds you set by `SLEEP` env var.  

For example:  
`docker run -d --name update-ipset --hostname update-ipset -e SLEEP=300 -v /host/path:/data neomediatech/update-ipset`  
It runs every 5 minutes.  

Logs are written to stdout.

### Variables

These variables can be passed to the container from docker-compose.yml or directly by command line:

| Variable         | Default | Description                                                   |
| ---------------- | ------- | ------------------------------------------------------------- |
| SLEEP            | 600     | How many seconds to wait before running the next update       |
| ENV_IPSETS_APPLY | 0       | Enables or disables the automatic ipsets update in the kernel |

In `/data/ipsets/ipsets.d` folder you can put your own download list logic, for example see [HERE](ipsets.d/)  

Other default settings can be found on [original repo](https://github.com/firehol/blocklist-ipsets/wiki/Downloading-IP-Lists).  
### Default settings
- By deafult ipsets are NOT applied to the kernel (`IPSETS_APPLY = 0`), if you need it set `ENV_IPSETS_APPLY = 1`. The container must be run with `--cap-add=NET_ADMIN` setting
- `/data/ipsets/ipsets.d` folder is used for your own download list logic
- Web folder is placed in `/data/ipsets/web`
- BASE_DIR is in /data/ipsets

## To Do
- [ ] Write results in log file (useful?)

