#!/usr/bin/env bash
set -euo pipefail

# Default JVM flags
JAVA_FLAGS="${JAVA_FLAGS:--XX:+UseG1GC -XX:MaxGCPauseMillis=200}"

cd /Server

# Read the Docker-imposed hard memory limit (in MB)
get_container_mem_limit_mb() {
    # cgroup v2
    if [ -f /sys/fs/cgroup/memory.max ]; then
        local val
        val=$(cat /sys/fs/cgroup/memory.max)
        if [ "$val" != "max" ]; then
            echo $(( val / 1048576 ))   # bytes → MB
            return
        fi
    fi
    # cgroup v1
    if [ -f /sys/fs/cgroup/memory/memory.limit_in_bytes ]; then
        local val
        val=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
        # A huge value like 9e18 means "no limit"; use 4 GB fallback
        if [ "$val" -gt 9000000000000000000 ] 2>/dev/null; then
            echo 4096
        else
            echo $(( val / 1048576 ))
        fi
        return
    fi

    # If nothing found, safe fallback
    echo 4096
}

total_mb=$(get_container_mem_limit_mb)
echo "Container hard memory limit: ${total_mb} MB"

# Max Heap = 75% of the limit
heap_mb=$(( total_mb * 75 / 100 ))
echo "Java max heap (-Xmx): ${heap_mb}M"

# Initial heap = 25% of max
xms_mb=$(( heap_mb / 4))
echo "Java initial heap (-Xms): ${xms_mb}M"

# Remove -Xms/-Xmx from JAVA_FLAGS 
JAVA_FLAGS_CLEAN=$(echo "$JAVA_FLAGS" | sed -E 's/-Xm[sx][[:space:]]*[^[:space:]]+//g')

# Build final arguments
read -ra JAVA_ARGS <<< "$JAVA_FLAGS_CLEAN"
JAVA_ARGS+=("-Xms${xms_mb}M" "-Xmx${heap_mb}M")

# Start Minecraft
exec java "${JAVA_ARGS[@]}" -jar server-launch.jar nogui