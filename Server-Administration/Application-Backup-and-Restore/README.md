# Application Backup and Restore — Hands-On Lab

**Competency:** Server Administration Roles and Responsibilities — Server Admin  
**Requirement:** Demonstrate ability / experience to configure backups for applications and servers.  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2, host `msi-aegis-zs2`

## Excel Competency Summary

Configured and tested a repeatable Linux application backup process using a shell script and timestamped compressed archives. Verified backup contents, performed a restore test, and confirmed restored data integrity against the original using matching SHA-256 checksums.

## Demo Summary / Presentation Talking Points

For this competency, I configured a repeatable backup process for application data on Linux. I created a shell script that packages the application directory into a timestamped compressed archive, verified that the archive contained the expected data, restored the backup into a separate test location, and compared the original and restored files with SHA-256.

The matching SHA-256 checksums confirmed that the restored data was byte-for-byte identical to the original.

**Backup flow:** **Data → Script → Backup → Inspect → Restore → Verify**

### 30-Second Demo Version

> I configured a repeatable Linux application backup process using a shell script that creates timestamped compressed archives. I verified the backup contents, restored the application data into a separate test location, and used SHA-256 checksums to confirm that the restored file was identical to the original.

## 1. Create Test Application Data

I created a safe application-data directory and sample data:

```bash
mkdir -p ~/dso-tap-backup-lab/app
echo "DSO-TAP team application data" > ~/dso-tap-backup-lab/app/app-data.txt
cat ~/dso-tap-backup-lab/app/app-data.txt
```

Observed:

```text
DSO-TAP team application data
```

## 2. Configure a Repeatable Backup

I created a dedicated backup directory:

```bash
mkdir -p ~/dso-tap-backup-lab/backups
```

I then created `~/dso-tap-backup-lab/backup.sh`:

```bash
#!/bin/bash

TIMESTAMP=$(date +%Y%m%d-%H%M%S)

tar -czf "$HOME/dso-tap-backup-lab/backups/app-$TIMESTAMP.tar.gz" \
    -C "$HOME/dso-tap-backup-lab" app

echo "Backup completed: app-$TIMESTAMP.tar.gz"
```

I made the script executable:

```bash
chmod +x ~/dso-tap-backup-lab/backup.sh
```

This changed the backup from an ad-hoc copy command into a repeatable procedure.

## 3. Run the Backup

I executed the configured backup:

```bash
~/dso-tap-backup-lab/backup.sh
ls -lh ~/dso-tap-backup-lab/backups
```

The run created:

```text
app-20260929-113831.tar.gz
```

The timestamped filename distinguishes backup runs and preserves when the backup was created.

## 4. Verify Backup Contents

Before relying on the archive, I inspected its contents:

```bash
tar -tzf ~/dso-tap-backup-lab/backups/app-20260929-113831.tar.gz
```

The archive contained the application directory and its data file.

## 5. Perform a Restore Test

I created a separate restore-test location and extracted the archive:

```bash
mkdir -p ~/dso-tap-backup-lab/restore-test

tar -xzf ~/dso-tap-backup-lab/backups/app-20260929-113831.tar.gz \
  -C ~/dso-tap-backup-lab/restore-test

cat ~/dso-tap-backup-lab/restore-test/app/app-data.txt
```

Recovered content:

```text
DSO-TAP team application data
```

This demonstrated that the backup was usable for recovery rather than merely proving that an archive file existed.

## 6. Verify Restored Data Integrity

I compared the original and restored files:

```bash
sha256sum ~/dso-tap-backup-lab/app/app-data.txt
sha256sum ~/dso-tap-backup-lab/restore-test/app/app-data.txt
```

Both produced the same SHA-256 digest:

```text
284ea6af59b0762df67aa22eebb4d21f8be5fd698aa7e20067c30db53f67ca21
```

The matching checksums confirmed that the restored application data was byte-for-byte identical to the original.

## Skills Demonstrated

- Linux application-data backup
- Bash backup scripting
- Executable script permissions
- Timestamped backup archives
- Compressed `tar` archive creation
- Backup-content inspection
- Restore testing
- SHA-256 integrity verification
- Repeatable backup and recovery procedure

## Completion

This lab provides hands-on evidence of configuring and testing an application backup process. The backup was created through a repeatable script, inspected, restored into a separate location, and verified for data integrity rather than being assumed usable.
