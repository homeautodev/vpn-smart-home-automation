
# 📡 WireGuard Tunnel: iPad ⇄ VPS ⇄ Physical Server

This setup allows secure, routed access from an iPad over the internet to a physical home server using a Virtual Private Server (VPS) as a middle point.

---

## 🔧 Architecture Overview

```
iPad (10.10.10.2)
     ⇅  WireGuard
VPS (10.10.10.1)
     ⇅  Routing (no NAT)
Physical Server (10.10.10.3 → 192.168.178.55)
```

---

## 📘 Key Mapping

| Device          | WG IP         | Real IP             | Public Key           |
|-----------------|---------------|----------------------|-----------------------|
| iPad            | 10.10.10.2    | dynamic LTE          | `<YOUR_PUBLIC_KEY>`   |
| VPS             | 10.10.10.1    | `<YOUR_VPS_IP>`      | `<YOUR_PUBLIC_KEY>`   |
| Home Server     | 10.10.10.3    | `<YOUR_LOCAL_SERVER_IP>`|<YOUR_PUBLIC_KEY>` |

---

## 🛠 Configuration Files

### 🔹 VPS (`/etc/wireguard/wg0.conf`)
```ini
[Interface]
Address = 10.10.10.1/24
PrivateKey = <YOUR_PRIVATE_KEY>
ListenPort = 51820

[Peer] # iPad
PublicKey = <YOUR_PUBLIC_KEY>
AllowedIPs = 10.10.10.2/32
PersistentKeepalive = 25

[Peer] # Physical Server
PublicKey = <YOUR_PUBLIC_KEY>
AllowedIPs = 10.10.10.3/32, <YOUR_LOCAL_SERVER_IP>/32
PersistentKeepalive = 25
```

---

### 🔹 Physical Server (`/etc/wireguard/wg0.conf`)
```ini
[Interface]
Address = 10.10.10.3/24
PrivateKey = <YOUR_PRIVATE_KEY>
ListenPort = 36429
PostUp = iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE

[Peer]
PublicKey = <YOUR_PUBLIC_KEY>
Endpoint = <YOUR_VPS_IP>:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

---

### 🔹 iPad Configuration
```ini
[Interface]
Address = 10.10.10.2/32
PrivateKey = <YOUR_PRIVATE_KEY>
DNS = 1.1.1.1

[Peer]
PublicKey = <YOUR_PUBLIC_KEY>
Endpoint = <YOUR_VPS_IP>:51820
AllowedIPs = 10.10.10.0/24, <YOUR_LOCAL_SERVER_IP>/32
PersistentKeepalive = 25
```

---

## 🔍 VPS Firewall and Forwarding Checks

### ✅ UFW
```bash
sudo ufw status verbose
# → should show: allow (routed)
sudo ufw default allow routed
```

### ✅ UFW Rules
```bash
sudo ufw allow in on wg0
sudo ufw allow out on wg0
sudo ufw allow 51820/udp
```

### ✅ Enable IPv4 forwarding
```bash
sudo nano /etc/sysctl.conf
# Uncomment or add: net.ipv4.ip_forward=1
sudo sysctl -p
```

---

## 🧪 Final Connectivity Tests
```bash
ping 10.10.10.1   # VPS
ping 10.10.10.3   # Home Server
```

- Open Home Assistant: `http://<YOUR_LOCAL_SERVER_IP>:8123`

---

## 🚑 Troubleshooting

```bash
sudo ufw default allow routed
sudo systemctl restart wg-quick@wg0
sudo wg show
```
