# Server Monitor 2.0


[![Docker Ready](https://img.shields.io/badge/docker-ready-blue.svg)]()
[![Stars](https://img.shields.io/github/stars/Caripson/server-monitor)]()
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)]()

Open-source, plug-and-play server & network monitoring with Bash/Python agents, InfluxDB 2.x, Grafana 10+ dashboards, public leaderboard, and real-time alerts.

---

## 🚀 Quick Start (Docker Compose)

1. Clone the repo and enter the directory:
    ```bash
    git clone https://github.com/Caripson/server-monitor.git
    cd server-monitor
    ```

2. Start InfluxDB and Grafana:
    ```bash
    docker compose up -d
    ```

- InfluxDB: http://localhost:8086  
  User: `admin`, Password: `supersecret`, Org: `server-monitor`, Token: `mytoken`
- Grafana: http://localhost:3000  
  User: `admin`, Password: `admin`

---

## 🕵️‍♂️ Add Monitoring Agents

Define your endpoints in `endpoints.yml`:

```yaml
agent: your-unique-agent-name  # e.g. johancar-stockholm-home

endpoints:
  - url: https://www.google.com/
    name: Google
    type: http
  - url: 8.8.8.8
    name: Google DNS
    type: ping
```

**Run the Bash agent:**
```bash
pip install pyyaml  # for yaml parsing
chmod +x agent.sh
./agent.sh
```

**Or use the Python agent:**
```bash
pip install requests pyyaml
python3 agent.py
```

Metrics are sent directly to InfluxDB.  
Run on any server, VM or your local machine!

---

## 📊 Automatic Grafana Setup

Dashboards and InfluxDB datasource are provisioned automatically!

- Open Grafana ([http://localhost:3000](http://localhost:3000), admin/admin)
- Dashboard: “Server Monitor” (in root folder)
- Data is available as soon as your agent is running.

---

## 🌍 Join the Community Monitor

Want to contribute your measurements to the public leaderboard?

1. Add a unique `agent` name in your `endpoints.yml`.
2. Change your agent’s InfluxDB URL and TOKEN to the community server (see wiki for details).
3. Start your agent – your data feeds the public dashboard!

**See the public dashboard:**  
[https://grafana.com/grafana/dashboards/](https://grafana.com/grafana/dashboards/)

---

## 📡 Public REST API

Want to fetch raw metrics or build your own dashboard?

**Example:** Query average HTTP latency (last 24h)
```bash
curl -G "https://community.monitor.example.com/api/v2/query?org=server-monitor"   -H "Authorization: Token YOUR_PUBLIC_TOKEN"   --data-urlencode 'query=from(bucket: "public") |> range(start: -24h) |> filter(fn: (r) => r._field == "time_total") |> group(columns:["agent"]) |> mean()'
```
See [InfluxDB 2.x API Docs](https://docs.influxdata.com/influxdb/v2.0/api/) for more info.

---

## 🚨 Alerts & Notifications

Set up alerts in Grafana for real-time monitoring!

- Slack, Discord, email, or any webhook
- Example: Alert if any endpoint has time_total > 2 seconds
- Go to: Alerting → Contact points → Add your notifier
- Create alert rule on any panel with your threshold

> See Grafana docs: https://grafana.com/docs/grafana/latest/alerting/

---

## 🛠️ Building on the Data: API & Anomaly Detection

- Fetch your metrics via the REST API (see above).
- Use included example scripts to detect anomalies or build your own integrations.
- Easily trigger Slack, mail, or dashboard updates from code.

---

## 🤝 Contributing

Want to help?  
- Fork this repo & create a feature branch  
- Add your scripts, dashboards or docs  
- Open a pull request!  
- Or open an Issue for bugs, feature ideas or feedback

*All contributors get a mention in the README and leaderboard if you want!*

---

## 🗺️ Roadmap

See [ROADMAP.md](./ROADMAP.md) for planned features and progress.

---

## ❓ FAQ

- **“I can't connect my agent to InfluxDB?”**  
  Make sure you're using the correct URL, org, bucket, and token (see Quick Start).
- **“How do I set up alerts for email instead of Slack?”**  
  Use Grafana alerting (Alerting → Contact Points → Add Email).
- **“Can I run the agent on Windows/Mac?”**  
  Yes! Both Bash and Python agents work cross-platform.

---

## 💬 Community

Questions? Want to discuss monitoring or share your dashboards?
- Or open a GitHub Discussion

---

