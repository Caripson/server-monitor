import requests
import time
import yaml
import subprocess

INFLUX_URL = "http://localhost:8086/api/v2/write?org=server-monitor&bucket=monitoring&precision=s"
TOKEN = "mytoken"

with open("endpoints.yml") as f:
    config = yaml.safe_load(f)

agent_name = config.get("agent", "anonymous")

for e in config["endpoints"]:
    name = e["name"]
    url = e["url"]
    typ = e.get("type", "http")
    timestamp = int(time.time())
    if typ == "http":
        try:
            r = requests.get(url, timeout=5)
            total_time = r.elapsed.total_seconds()
            line = f'monitor,name={name},type={typ},agent={agent_name} time_total={total_time} {timestamp}'
        except Exception:
            line = f'monitor,name={name},type={typ},agent={agent_name} time_total=0 {timestamp}'
    elif typ == "ping":
        try:
            output = subprocess.check_output(f'ping -c 1 -w 1 {url}', shell=True).decode()
            ms = float(output.split("time=")[-1].split(" ")[0])
            line = f'monitor,name={name},type={typ},agent={agent_name} ping_time={ms} {timestamp}'
        except Exception:
            line = f'monitor,name={name},type={typ},agent={agent_name} ping_time=0 {timestamp}'
    else:
        continue
    headers = {"Authorization": f"Token {TOKEN}"}
    requests.post(INFLUX_URL, data=line, headers=headers)
