# Server Sizing — Hands-On Capacity Assessment

**Competency:** Server Administration Roles and Responsibilities — Server Admin  
**Requirement:** Demonstrate ability to size servers to host an application.  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2, host `msi-aegis-zs2`  
**Application:** Nginx web server

## Excel Competency Summary

Evaluated server sizing for a small Nginx application by measuring CPU load, memory usage, and storage requirements. Determined that the current 24-CPU / 15-GB environment was oversized and recommended a smaller baseline of 1–2 vCPU, 1–2 GB RAM, and modest storage with monitoring and growth headroom.

## Demo Summary / Presentation Talking Points

For this competency, I evaluated the resource requirements of a small Nginx web application instead of choosing a server size by guesswork.

I measured the available CPU capacity, current CPU load, memory usage, Nginx process memory, and application storage footprint. The environment exposed 24 logical CPUs and about 15.5 GiB of memory, while the measured workload was extremely light: CPU utilization was near idle, Nginx used only a small amount of memory, and the website content occupied only 12 KB.

Based on the measured demand, I concluded that the current environment was significantly oversized for this application. I recommended a much smaller starting point of **1–2 vCPU, 1–2 GB RAM, and approximately 5–10 GB of storage**, with monitoring and capacity headroom for future growth.

**Sizing method:** **Measure → Right-size → Leave headroom → Monitor → Resize**

### 30-Second Demo Version

> I sized a small Nginx web server by measuring actual CPU, memory, and storage usage. The current environment had 24 logical CPUs and about 15.5 GB of RAM, but the workload was nearly idle and the site used only 12 KB of storage. Based on the evidence, I recommended a smaller baseline of 1–2 vCPU, 1–2 GB RAM, and modest storage, with monitoring and headroom for growth.

## 1. Check Available CPU Capacity

I checked how many logical CPUs Linux could use:

```bash
nproc
```

Observed:

```text
24
```

I also identified the processor:

```bash
lscpu | grep -E '^CPU\(s\)|Model name'
```

Observed:

```text
Model name: AMD Ryzen 9 9900X 12-Core Processor
```

The host exposed 24 logical processing units to the Linux environment.

## 2. Measure Current System Load

I checked system load and CPU utilization:

```bash
uptime
top -bn1 | head -n 5
```

Observed:

```text
load average: 0.01, 0.01, 0.00
%Cpu(s): 0.4 us, 0.7 sy, 98.9 id
```

This showed that the CPU was almost completely idle during the measurement.

## 3. Measure Memory Capacity and Usage

The same `top` output showed:

```text
MiB Mem : 15511.7 total
13755.4 free
740.9 used
14770.8 available
```

Swap usage was:

```text
4096.0 MiB total
0.0 used
```

The environment therefore had substantially more memory than the application required.

## 4. Measure Nginx Process Usage

I inspected the Nginx processes:

```bash
ps -C nginx -o pid,comm,%cpu,%mem,rss
```

Observed:

- Nginx processes showed approximately `0.0%` CPU at the time of measurement.
- Worker RSS values were roughly 5 MB each.
- The total Nginx memory footprint was small relative to the 15.5 GiB available in the environment.

This confirmed that CPU and memory demand from the web service were low.

## 5. Measure Application Storage

I checked the web-content directory:

```bash
du -sh /var/www
```

Observed:

```text
12K /var/www
```

The current application content therefore required very little storage.

## 6. Sizing Decision

Based on the measurements:

| Resource | Current Environment | Observed Demand | Recommended Starting Size |
| --- | --- | --- | --- |
| CPU | 24 logical CPUs | Near idle | 1–2 vCPU |
| Memory | ~15.5 GiB | Low usage | 1–2 GB RAM |
| Storage | Large host filesystem | 12 KB site content | 5–10 GB |
| Network | Local HTTP service | Light demo traffic | Basic connectivity |
| Growth | Large unused capacity | Minimal workload | Monitor and scale as needed |

### Recommended Baseline

For this small internal/development Nginx workload:

```text
CPU:      1–2 vCPU
Memory:   1–2 GB RAM
Storage:  5–10 GB
Network:  Basic connectivity
Headroom: Monitor and resize if demand grows
```

The current WSL environment is intentionally much larger than this workload requires, so it should not be used as the target production size.

## 7. Sizing Principle

Server sizing should not mean selecting the largest machine available.

A better process is:

```text
Measure workload
      ↓
Estimate required capacity
      ↓
Add reasonable headroom
      ↓
Deploy
      ↓
Monitor
      ↓
Resize when usage changes
```

This balances application reliability with efficient resource use.

## Skills Demonstrated

- CPU-capacity inspection
- Linux load interpretation
- CPU-utilization analysis
- Memory-capacity and usage analysis
- Application-process resource inspection
- Storage-footprint measurement
- Workload-based right-sizing
- Capacity headroom planning
- Avoiding over-provisioning
- Evidence-based server-sizing recommendation

## Completion

This lab provides hands-on evidence of sizing a server for an application by measuring actual CPU, memory, and storage demand, comparing the workload with available capacity, and producing a right-sized starting recommendation with monitoring and growth headroom.
