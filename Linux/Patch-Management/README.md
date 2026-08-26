# Linux Patch Management — Hands-On Demo

## Objective

This lab demonstrates the ability to safely check for, install, verify, and document Linux operating-system patches.

By completing this lab, you will understand how to:

- Identify the Linux distribution
- Check for available package updates
- Review updates before installation
- Install security and system patches
- Verify patch installation
- Determine whether a reboot is required
- Validate the system after patching
- Follow basic patch-management safety practices

---

## 1. What Is Patching?

A **patch** is an update that fixes or improves software already installed on a system.

Patches may address:

- Security vulnerabilities
- Software bugs
- Stability problems
- Compatibility issues
- Performance improvements

A simple patch-management workflow is:

```text
Check System
     ↓
Check Available Updates
     ↓
Review Changes
     ↓
Install Patches
     ↓
Verify
     ↓
Reboot if Required
     ↓
Validate System
```

---

## 2. 3rd-Grade Analogy — Fixing a Bicycle

Think of a Linux server as a **bicycle**.

Sometimes a screw becomes loose, a tire needs replacing, or the brakes need adjustment. You do not throw away the whole bicycle. You repair the part that needs attention.

Linux patches work in a similar way:

```text
Linux Server
     ↓
Problem Found
     ↓
Patch Available
     ↓
Install Fix
     ↓
System Is More Secure / Reliable
```

> **A patch is like repairing a part of your bicycle so you can keep using it safely.**

---

## 3. Identify the Linux Distribution

Before patching, determine which Linux distribution you are using:

```bash
cat /etc/os-release
```

Common package managers include:

```text
Ubuntu / Debian            → apt
RHEL / Rocky / AlmaLinux   → dnf
Older RHEL/CentOS systems  → yum
```

Different distributions use different package-management tools, so identifying the operating system first is important.

---

## 4. Check the Current System

Before making changes, gather basic information:

```bash
hostname
uname -r
uptime
df -h
```

These commands help confirm:

- Which server you are working on
- Current running kernel version
- How long the server has been running
- Whether sufficient filesystem space is available

---

## 5. Ubuntu / Debian — Check for Updates

Refresh package metadata:

```bash
sudo apt update
```

This does **not** install the available patches. It refreshes the local package information.

Check packages that can be upgraded:

```bash
apt list --upgradable
```

Easy way to remember:

```text
apt update
= Refresh information about available packages.

apt upgrade
= Install available package upgrades.
```

---

## 6. Ubuntu / Debian — Install Patches

After reviewing the available updates, run:

```bash
sudo apt upgrade
```

The package manager displays the proposed changes and normally asks for confirmation.

Some controlled automation or lab environments may use:

```bash
sudo apt upgrade -y
```

In production, automatically accepting all changes should be used only when it is consistent with the organization's patching and change-management process.

---

## 7. RHEL / Rocky / AlmaLinux — Check for Updates

On modern Red Hat-based distributions:

```bash
sudo dnf check-update
```

Where supported, security/update information can be reviewed with:

```bash
sudo dnf updateinfo
```

---

## 8. RHEL-Based Systems — Install Patches

Install available package upgrades:

```bash
sudo dnf upgrade
```

Review the proposed changes before confirming them.

Controlled environments may use:

```bash
sudo dnf upgrade -y
```

Older systems may use:

```bash
sudo yum update
```

---

## 9. Verify the Patches

After patching, check whether relevant updates remain.

### Ubuntu / Debian

```bash
apt list --upgradable
```

### RHEL-Based Systems

```bash
sudo dnf check-update
```

Also verify the applications and services that matter to the system rather than relying only on the package-manager result.

---

## 10. Check the Running Kernel

Kernel updates often require a reboot before the newly installed kernel becomes active.

Check the currently running kernel:

```bash
uname -r
```

If necessary, compare the running version with the kernel packages installed by the patch operation.

---

## 11. Determine Whether a Reboot Is Required

### Ubuntu / Debian

Some Ubuntu/Debian environments create a reboot-required marker:

```bash
test -f /var/run/reboot-required && echo "Reboot required"
```

### RHEL-Based Systems

Where the appropriate tooling is installed, a command such as the following may be available:

```bash
sudo dnf needs-restarting -r
```

Exact reboot-detection tools can vary by distribution and installed packages.

---

## 12. Reboot if Required

If a reboot is required and the approved maintenance process allows it:

```bash
sudo reboot
```

Before rebooting a production server, confirm items such as:

- Approved maintenance/change window
- Application availability requirements
- Dependencies and downstream impact
- Backup or recovery procedures
- Required stakeholder notifications

---

## 13. Validate After Reboot

After reconnecting to the server, perform validation such as:

```bash
uptime
uname -r
systemctl --failed
```

Verify important application services where applicable:

```bash
systemctl status <service-name>
```

For example:

```bash
systemctl status nginx
```

The goal is to confirm:

```text
Server Restarted
      ↓
Expected Kernel Running
      ↓
Critical Services Running
      ↓
No Unexpected Failures
```

---

## 14. Patch Management Safety

Patching should not simply mean running an update command and assuming everything worked.

A safer operational workflow is:

```text
Review
  ↓
Backup / Recovery Plan
  ↓
Maintenance Window
  ↓
Install
  ↓
Reboot if Required
  ↓
Validate
  ↓
Document
```

Important production considerations include:

- Test important changes before production when practical
- Understand how to recover if an update causes problems
- Review relevant security and release information
- Use an approved maintenance/change window where required
- Confirm sufficient disk space
- Verify critical services afterward
- Record what changed and the validation result

---

## 15. Why Patching Matters

Unpatched systems may continue running software with known vulnerabilities or defects.

Conceptually:

```text
Vulnerability Discovered
        ↓
Vendor Creates Fix
        ↓
Patch Released
        ↓
Administrator Reviews and Installs Patch
        ↓
Exposure Reduced
```

Patch management is therefore an important part of system security, reliability, and operations.

---

## 16. Key Commands

| Purpose | Ubuntu / Debian | RHEL-Based |
| --- | --- | --- |
| Identify OS | `cat /etc/os-release` | `cat /etc/os-release` |
| Refresh/check updates | `sudo apt update` | `sudo dnf check-update` |
| List available upgrades | `apt list --upgradable` | `sudo dnf check-update` |
| Install updates | `sudo apt upgrade` | `sudo dnf upgrade` |
| Check running kernel | `uname -r` | `uname -r` |
| Restart system | `sudo reboot` | `sudo reboot` |
| Check failed services | `systemctl --failed` | `systemctl --failed` |

---

## 17. Skills Demonstrated

```text
Identify Linux Distribution
          ↓
Inspect Current System
          ↓
Check Available Patches
          ↓
Review Updates
          ↓
Install Updates
          ↓
Check Reboot Requirement
          ↓
Reboot if Necessary
          ↓
Validate System and Services
          ↓
Document Results
```

These skills are important for Linux administration, DevOps, cloud engineering, security operations, server maintenance, and infrastructure management.

---

## One-Sentence Summary

> **Linux patch management means safely identifying, reviewing, installing, verifying, and documenting operating-system and software updates to keep systems secure and reliable.**
