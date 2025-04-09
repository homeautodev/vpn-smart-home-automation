# VPN Smart Home Automation

Secure, monitorable remote access to your smart home using **WireGuard**, systemd automation, and ISO-based backup strategies.

---

## 📦 Features

- WireGuard VPN tunnel: iPad ⇄ VPS ⇄ Home Server (Debian 12)
- systemd-based watchdog for connection drop detection
- VPS ISO backup & restore automation
- Clean modular project layout

---

## 📐 Architecture

![VPN Architecture](docs/vpn-architecture.png)

---

## ⚙️ Installation

```bash
sudo apt install wireguard ufw systemd
cp wireguard-setup/wg0.conf /etc/wireguard/
wg-quick up wg0
```

Set up systemd timer:

```bash
cp monitor-restart-vpn/*.service /etc/systemd/system/
systemctl daemon-reexec
systemctl enable --now wg-monitor.timer
```

---

## 🧪 ISO Backup & Restore

- Run `backup_to_iso.sh` to create an image of the system
- Transfer ISO offsite
- Mount and restore when needed

---

## 🛠 Technologies Used

- WireGuard
- systemd & timers
- Bash
- Linux (Debian 12)
- UFW
- Home Assistant (integrated via VPN)

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
