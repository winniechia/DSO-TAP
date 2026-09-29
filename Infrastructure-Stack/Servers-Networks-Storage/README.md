# Servers, Networks, and Storage — Hands-On Infrastructure Lab

**Competency:** Core Infrastructure Stack Components — Servers, Networks, Storage  
**Requirement:** Demonstrate ability / experience to configure and maintain servers, network, and storage components for a small development team.  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2, host `msi-aegis-zs2`

## Excel Competency Summary

Demonstrated hands-on administration of server, network, and storage components in Linux/WSL2. Validated server health/resources, IP/subnet/gateway/routing, Internet and DNS connectivity, listening ports, storage usage, and least-privilege permissions. Created and verified a SHA-256 backup, simulated data loss, restored the file, and confirmed data integrity.

## Demo Summary / Presentation Talking Points

For this competency, I demonstrated the three core infrastructure components for a small development team: **server, network, and storage**.

I first validated the Linux server environment by checking its hostname, kernel, current time, uptime, system load, memory, and filesystem capacity. I then inspected the network configuration, identified the IP address, subnet, default gateway, and route, and verified both external IP connectivity and DNS resolution. I also inspected listening network sockets.

For storage administration, I created application data, applied least-privilege file permissions, checked disk usage, and created a backup. I verified the backup with SHA-256, deliberately removed the original file, restored it from backup, and verified the restored file again.

**Key lesson:** Maintaining infrastructure is not just creating resources. A SysAdmin must be able to **inspect, secure, troubleshoot, verify, back up, and recover** them.

### 30-Second Demo Version

> I demonstrated server, network, and storage administration for a small development environment. I checked the Linux server's health and resources, validated its IP address, subnet, gateway, routing, Internet connectivity, DNS, and listening ports, then managed application storage and permissions. Finally, I created and verified a backup, simulated data loss, restored the file, and verified its integrity again.

**Memory aid:** **Server → Network → Storage → Backup → Restore**


## 3rd-Grade Analogy

A small development team's infrastructure is like a school:

- **Server** = the classroom computer where work happens.
- **Network** = the hallways and doors that let computers communicate.
- **Storage** = the filing cabinet where data is kept.
- **Backup** = a safe photocopy of important work.

## 1. Server Administration Baseline

I inspected the Linux host and its current operating state.

```bash
hostname
uname -a
date
uptime
df -h
free -h
```

Observed results included:

- Hostname: `msi-aegis-zs2`
- Kernel: `6.18.33.1-microsoft-standard-WSL2`
- Architecture: `x86_64 GNU/Linux`
- System date verified as September 29, 2026
- Uptime at test time: 3 minutes
- Load average: `0.00, 0.00, 0.00`
- Memory: 15 GiB total, about 14 GiB available at test time
- Swap: 4.0 GiB total, 0 B used

### Kernel build date vs. current date

The date shown by `uname -a` is kernel build information, not the current system date. I verified the current system clock separately with `date`.

## 2. Storage Inspection

I used `df -h` to inspect mounted filesystems.

Important observations:

- WSL Linux root filesystem: `/dev/sdd`, approximately 1007 GiB
- Windows `C:\` is mounted in WSL at `/mnt/c`
- The DSO-TAP working directory under `/mnt/c/...` therefore uses Windows-backed storage from inside Linux.

This demonstrated the distinction between a Linux filesystem and a Windows filesystem mounted into WSL.

## 3. Network Configuration and Troubleshooting

### Interface and IP address

```bash
ip addr
```

Observed:

- Main interface: `eth0`
- Interface state: `UP`
- IPv4 address: `172.17.226.160/20`
- Loopback: `127.0.0.1`

### Routing

```bash
ip route
```

Observed:

- Local network: `172.17.224.0/20`
- Default gateway: `172.17.224.1`
- Default traffic leaves through `eth0`

### External connectivity

```bash
ping -c 4 8.8.8.8
```

Result: 4 packets transmitted, 4 received, 0% packet loss.

This verified IP connectivity and routing independently of DNS.

### DNS resolution

```bash
ping -c 4 google.com
```

The hostname resolved to an IP address and all four packets returned with 0% packet loss. This verified DNS resolution together with network connectivity.

### Listening sockets

```bash
ss -tuln
```

The system showed TCP/UDP sockets including port 53 used for DNS-related services. A listening socket does not by itself mean the service is reachable from the Internet; routing, address binding, firewalls, and cloud controls such as security groups also affect reachability.

## 4. Storage Management

I created a safe application-data test directory in the Linux home filesystem:

```bash
mkdir -p ~/dso-tap-storage-lab
cd ~/dso-tap-storage-lab
echo "DSO-TAP application data" > app-data.txt
ls -lh
cat app-data.txt
```

The application data was successfully written and read back.

### Permissions / least privilege

Initial permissions were `-rw-r--r--`. I restricted the file to its owner:

```bash
chmod 600 app-data.txt
ls -l app-data.txt
```

Result:

```text
-rw------- 1 dev dev 25 Sep 29 10:17 app-data.txt
```

This allows the owner to read/write while denying group and other access.

### Directory disk usage

```bash
du -sh ~/dso-tap-storage-lab
```

Observed disk usage: `8.0K`.

`df` answers how much space a filesystem has; `du` measures space used by a particular file or directory.

## 5. Backup, Integrity Verification, and Restore

I created a separate backup location and copied the application data:

```bash
mkdir -p ~/dso-tap-backups
cp ~/dso-tap-storage-lab/app-data.txt ~/dso-tap-backups/app-data.txt
ls -l ~/dso-tap-backups
```

### Verify backup integrity

```bash
sha256sum ~/dso-tap-storage-lab/app-data.txt
sha256sum ~/dso-tap-backups/app-data.txt
```

Both files produced the same SHA-256 digest:

```text
ac27534decfa239028a2ab3e7e12105577a749b40c2038139f632136440f415a
```

This verified that the backup matched the original byte-for-byte.

### Restore test

I deliberately removed the original file:

```bash
rm ~/dso-tap-storage-lab/app-data.txt
ls -l ~/dso-tap-storage-lab
```

The directory was empty. I then restored the file from backup:

```bash
cp ~/dso-tap-backups/app-data.txt ~/dso-tap-storage-lab/app-data.txt
cat ~/dso-tap-storage-lab/app-data.txt
sha256sum ~/dso-tap-storage-lab/app-data.txt
```

Recovered content:

```text
DSO-TAP application data
```

The restored file produced the same SHA-256 digest as the original and backup.

**Recovery cycle demonstrated:** Backup → Verify → Simulated Loss → Restore → Verify.

## Troubleshooting Method Learned

A useful network troubleshooting sequence from this lab is:

1. Inspect the interface and IP address with `ip addr`.
2. Inspect the default gateway and routes with `ip route`.
3. Ping an IP address to test connectivity without relying on DNS.
4. Ping a hostname to test DNS resolution plus connectivity.
5. Inspect listening sockets with `ss -tuln`.

For storage, I verified capacity, usage, permissions, backup integrity, and successful restoration instead of assuming that a copied file was a usable backup.

## Skills Demonstrated

- Linux server baseline inspection
- Kernel, uptime, load, memory, and filesystem checks
- Network interface and IPv4 inspection
- Subnet and default-route interpretation
- External connectivity testing
- DNS troubleshooting
- TCP/UDP listening-port inspection
- Filesystem and mounted-storage awareness
- File creation and retrieval
- Linux permission management and least privilege
- Disk-usage inspection
- Application-data backup
- SHA-256 integrity verification
- Backup restoration and recovery validation

## Completion

This lab provides hands-on evidence for administering the **server, network, and storage** components of a small development-team environment. It also provides a practical foundation for the separate Server Administration competency covering application/server backups.
