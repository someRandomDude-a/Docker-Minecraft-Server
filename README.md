# Docker Minecraft Server

Runs A minecraft server on docker with playit for external tunnel access.

## How to configure?

### Step 1

Create a .env file with this format:

```.env
SECRET_KEY="YOUR PLAYIT KEY HERE"
JAVA_FLAGS=-XX:+UseZGC -XX:+ZGenerational -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:+PerfDisableSharedMem
```

### Step 2

Create a folder [`./Server`](./Server/)

### Step 3

Put your server files inside this folder.  
The main server jar must be named:  
`server-launch.jar` inside the root [`./Server`](./Server/) folder

### Step 4

Configure the RAM available to your server in [`docker_compose.yml`](./docker_compose.yml#19).  
`Memory limit` is the maximum your server will be allowed to use from host memory.  
`Memory reservation` is the threshold for docker to try and free memory from the container.  

## Technical Information

The playit service can be configured from [playit.gg](https://playit.gg)  
Get your PLAYIT token from thge agent setup wizard  
Configure one tunnel `Minecraft (Java)` and assign it to your agent  

The server is available at `localhost:25565` from your host computer.  
This can be modified by commenting [line 27 and 28 in the `docker_compose.yml`](./docker_compose.yml#27).  

