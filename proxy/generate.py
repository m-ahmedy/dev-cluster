import json
import os
from pathlib import Path
import yaml

# Setup
BASE_DIR = Path(".")
CONFIG_DIR = BASE_DIR / "configs"
CONFIG_DIR.mkdir(exist_ok=True)

START_PORT = 5000

# Load registries
with open("registries.json") as f:
    registries = json.load(f)

# --- 1. Generate config.yml for each registry
key_name_hashmap = {}
port = START_PORT
for key, remote_url in registries.items():
    config = {
        "version": 0.1,
        "proxy": {"remoteurl": remote_url},
        "storage": {
            "filesystem": {
                "rootdirectory": "/var/lib/registry"
            }
        },
        "http": {
            "addr": f":{port}"
        }
    }
    fname = CONFIG_DIR / f"{key.replace('.', '_')}.yml"
    with open(fname, "w") as f:
        yaml.dump(config, f)
    
    key_name_hashmap[key] = "./" + str(fname)
    port += 1


# --- 3. Generate docker-compose.yml
compose = {
    "version": "3.9",
    "services": {},
    "volumes": {}
}

# Add registry services

port = START_PORT
for i, key in enumerate(list(registries)):
    service = key.replace(".", "_") + "_registry"
    config_path = key_name_hashmap[key]
    volume_name = service + "_cache"

    host_path = f"./data/{key}"
    Path(host_path).mkdir(parents=True, exist_ok=True)

    compose["services"][service] = {
        "image": "registry:2",
        "restart": "always",
        "network_mode": "host",
        "volumes": [
            f"{volume_name}:/var/lib/registry",
            f"{config_path}:/etc/docker/registry/config.yml:ro"
        ],
    }

    compose["volumes"][volume_name] = {
        "driver": "local",
        "driver_opts": {
            "type": "none",
            "o": "bind",
            "device": host_path
        }
    }

    port += 1

# Dump to file
with open("docker-compose.yml", "w") as f:
    yaml.dump(compose, f, sort_keys=False)

print("✅ Generated docker-compose.yml, and all registry config files.")

print()