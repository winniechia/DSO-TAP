# Linux Logging — Hands-On Demo

## Summary

Linux logging is the ability to **record, locate, access, search, filter, monitor, and manage system and application events** so engineers can understand system behavior and troubleshoot problems.

This lab demonstrates how to:

- Locate common Linux logs
- Access logs with `journalctl` and standard command-line tools
- Generate a test log event
- Search and filter logs
- Monitor logs in real time
- Filter logs by service and time
- Create a simple application log
- Understand basic log rotation
- Use logs for troubleshooting

---

## 1. What Is a Log?

A **log** is a record of events that occurred on a computer or application.

Examples include:

```text
User logged in
Application started
Service stopped
Authentication failed
Error occurred
```

A log entry commonly contains information such as:

```text
Timestamp
   ↓
Hostname
   ↓
Service / Process
   ↓
Event / Message
```

Logs help answer:

> **What happened, when did it happen, and which system or service was involved?**

---

## 2. 3rd-Grade Analogy — The Computer's Diary

Imagine a teacher keeps a notebook recording important classroom events:

```text
9:00 — Class started
9:15 — Student entered
9:30 — Computer stopped working
9:32 — Computer restarted
```

Linux logs work similarly. The computer records events so we can look backward and investigate what happened.

> **A Linux log is like the computer's diary.**

---

## 3. Locate Common Linux Logs

Traditional Linux text logs are commonly stored under:

```text
/var/log
```

Explore the directory:

```bash
cd /var/log
ls
ls -lh
```

Depending on the Linux distribution and configuration, files may include:

```text
auth.log
syslog
messages
secure
kern.log
```

The exact log files vary by distribution and system configuration.

---

## 4. Read Log Files

For a text log that you have permission to access:

```bash
less /var/log/syslog
```

On some RHEL-based systems:

```bash
less /var/log/messages
```

Useful commands include:

```bash
cat filename
less filename
head filename
tail filename
```

For large log files, `less` and `tail` are generally more practical than displaying the entire file with `cat`.

---

## 5. Access the systemd Journal

Many modern Linux distributions use the **systemd journal**.

View journal entries:

```bash
journalctl
```

Show the most recent 20 entries:

```bash
journalctl -n 20
```

Show entries from the current boot:

```bash
journalctl -b
```

Show error-priority entries from the current boot:

```bash
journalctl -p err -b
```

Elevated privileges may be required to view all system log entries.

---

## 6. View Logs for a Specific Service

For example, if Nginx is installed:

```bash
sudo journalctl -u nginx
```

For SSH, the unit name may vary by distribution:

```bash
sudo journalctl -u ssh
```

or:

```bash
sudo journalctl -u sshd
```

A common troubleshooting workflow is:

```text
Service Fails
     ↓
Check Service Status
     ↓
Check Service Logs
     ↓
Find Relevant Error
     ↓
Investigate Cause
```

---

## 7. Monitor Logs in Real Time

Follow a traditional text log:

```bash
sudo tail -f /var/log/syslog
```

Follow the systemd journal:

```bash
sudo journalctl -f
```

Think of the difference as:

```text
less
= Read the diary

tail -f / journalctl -f
= Watch the diary being written
```

Press `Ctrl + C` to stop following the log.

---

## 8. Search and Filter Logs with grep

Search a log for errors:

```bash
grep "error" application.log
```

Perform a case-insensitive search:

```bash
grep -i "error" application.log
```

Search for several useful terms:

```bash
grep -Ei "error|failed|warning" application.log
```

Count matching lines:

```bash
grep -ic "error" application.log
```

This demonstrates basic log filtering and manipulation.

---

## 9. Combine Commands with Pipes

Linux commands can be connected to filter output.

Example:

```bash
journalctl | grep -i "error"
```

Another example:

```bash
journalctl -n 100 | grep -i "failed"
```

Conceptually:

```text
Logs
 ↓
Filter
 ↓
Relevant Events
```

---

## 10. Filter Logs by Time

With `journalctl`:

```bash
journalctl --since "1 hour ago"
```

or:

```bash
journalctl --since today
```

Filter both by service and time:

```bash
sudo journalctl -u nginx --since "1 hour ago"
```

This allows an engineer to focus on events from the time period relevant to an incident.

---

## 11. Create and Manipulate a Simple Custom Log

Create a lab directory:

```bash
mkdir -p ~/logging-demo
cd ~/logging-demo
```

Create several application log entries:

```bash
echo "$(date) INFO Application started" >> application.log
echo "$(date) INFO User logged in" >> application.log
echo "$(date) ERROR Database connection failed" >> application.log
```

View the log:

```bash
cat application.log
```

Search for the error:

```bash
grep "ERROR" application.log
```

This demonstrates:

```text
Create
  ↓
Write
  ↓
Read
  ↓
Search / Filter
```

---

## 12. Generate a System Log Event with logger

The `logger` command can send a message to the system logging facility:

```bash
logger "DSO-TAP logging lab test message"
```

Search for the event in the journal:

```bash
journalctl --since "5 minutes ago" | grep "DSO-TAP"
```

This demonstrates the ability to **generate a test event and retrieve it from the logging system**.

---

## 13. Understand Log Rotation

Traditional text logs can grow continuously if they are never managed.

Linux systems commonly use **logrotate** to rotate traditional log files.

Configuration is commonly found in:

```text
/etc/logrotate.conf
/etc/logrotate.d/
```

Inspect the configuration:

```bash
cat /etc/logrotate.conf
ls /etc/logrotate.d/
```

Conceptually:

```text
Current Log
     ↓
Rotate
     ↓
Old Log Archived
     ↓
Optional Compression
     ↓
Old Logs Eventually Removed
```

The systemd journal has its own storage and retention mechanisms, so it should not be assumed that all Linux logs are managed by `logrotate`.

---

## 14. Basic Troubleshooting Workflow

A practical logging workflow is:

```text
Something Is Broken
        ↓
Identify Service
        ↓
Check Status
        ↓
Read Logs
        ↓
Filter by Time
        ↓
Search for Error / Failed / Warning
        ↓
Identify Cause
        ↓
Fix
        ↓
Check Logs Again
```

Example:

```bash
systemctl status nginx
```

Then inspect recent logs:

```bash
sudo journalctl -u nginx --since "10 minutes ago"
```

---

## 15. Key Commands

| Command | Purpose |
| --- | --- |
| `journalctl` | Read the systemd journal |
| `journalctl -f` | Follow journal entries in real time |
| `journalctl -u` | Filter journal entries by systemd unit |
| `tail -f` | Follow a text log in real time |
| `less` | Inspect a large text log |
| `grep` | Search and filter text |
| `head` | Show the beginning of text output |
| `tail` | Show the end of text output |
| `logger` | Send a message to the system logging facility |
| `systemctl status` | Check systemd service/unit status |

---

## 16. Skills Demonstrated

```text
Understand Logs
      ↓
Locate Logs
      ↓
Access Logs
      ↓
Generate Test Event
      ↓
Read Logs
      ↓
Search / Filter
      ↓
Monitor in Real Time
      ↓
Understand Rotation
      ↓
Troubleshoot
```

These skills provide a foundation for later topics such as centralized logging, AWS CloudWatch, SIEM, alerting, incident response, monitoring, and observability.

---

## One-Sentence Takeaway

> **Linux logging is the ability to record, locate, read, filter, monitor, and manage system and application events so we can understand system behavior and troubleshoot problems.**
