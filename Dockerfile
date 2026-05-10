FROM eclipse-temurin:25-jre

RUN apt-get update && apt-get install -y bc && rm -rf /var/lib/apt/lists/*

# Set working directory to root
WORKDIR /

COPY start.sh /start.sh
RUN chmod +x /start.sh

# Set working directory to /Server (Minecraft will be here)
WORKDIR /Server

EXPOSE 25565

CMD ["/start.sh"]
