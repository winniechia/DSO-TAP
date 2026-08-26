# Linux File and Directory Management — Hands-On Demo

## Objective

This hands-on lab demonstrates the ability to manage files and directories in a Linux environment.

By completing the lab, you will practice how to:

- Navigate the Linux filesystem
- Create files and directories
- Copy, move, and rename files
- View file contents
- Search for files and text
- Delete files and directories safely
- Understand relative and absolute paths

---

## Lab Environment

This lab was completed in a Linux environment using **WSL (Windows Subsystem for Linux)**.

Example working directory:

```text
/mnt/c/users/winnie/AWS Solution Architect Exam Study/DSO-TAP/linux-file-demo
```

This is important because Linux commands such as `pwd`, `touch`, `find`, `cp`, `mv`, and `rm` are executed inside the Linux shell rather than Windows Command Prompt or PowerShell.

---

## 1. Check the Current Directory

Run:

```bash
pwd
```

`pwd` means **print working directory**. It tells you where you currently are in the filesystem.

Think of it as asking Linux:

> **Where am I right now?**

---

## 2. List Files and Directories

Run:

```bash
ls
ls -l
ls -la
```

- `ls` lists files and directories.
- `ls -l` displays a detailed listing.
- `ls -la` also displays hidden files and directories.

Think of `ls` as asking:

> **What is in this room?**

---

## 3. Create and Enter a Project Directory

```bash
mkdir linux-file-demo
cd linux-file-demo
pwd
```

---

## 4. Create Directories

```bash
mkdir documents
mkdir scripts
mkdir backups
mkdir -p projects/demo/config
```

The lab created a structure containing `documents`, `scripts`, `backups`, and the nested `projects/demo/config` directory.

---

## 5. Create Files

Create empty files with `touch`:

```bash
touch documents/notes.txt
touch scripts/hello.sh
```

Inspect the directory tree:

```bash
find .
```

During the completed lab, `find .` showed the created directories, including:

```text
.
./backups
./documents
./projects
./projects/demo
./projects/demo/config
./scripts
```

---

## 6. Add and View File Content

Add text to the notes file:

```bash
echo "Linux file management practice" > documents/notes.txt
```

Display it with:

```bash
cat documents/notes.txt
```

Other useful viewing commands include:

```bash
less documents/notes.txt
head documents/notes.txt
tail documents/notes.txt
```

---

## 7. Copy a File

The lab copied the notes file into the backup directory:

```bash
cp documents/notes.txt backups/notes-backup.txt
```

Verification:

```bash
ls backups
```

Observed result:

```text
notes-backup.txt
```

Think of `cp` as:

> **Make a photocopy.**

The original remains in its original location.

---

## 8. Move and Rename Files

The notes file was renamed with:

```bash
mv documents/notes.txt documents/linux-notes.txt
```

The `mv` command can be used to both move and rename filesystem objects.

Think of `mv` as:

> **Pick something up and put it somewhere else — or give it a new name.**

---

## 9. Search for Files

The completed lab searched for all `.txt` files:

```bash
find . -name "*.txt"
```

Observed result:

```text
./backups/notes-backup.txt
./documents/linux-notes.txt
```

To search inside files, use `grep`:

```bash
grep "Linux" documents/linux-notes.txt
```

Easy distinction:

```text
find = Where is the file?

grep = Where is the text?
```

---

## 10. Relative and Absolute Paths

An **absolute path** starts at the filesystem root `/` and describes the complete location.

A **relative path** describes a location relative to the current working directory.

Useful shortcuts include:

```text
.   current directory
..  parent directory
~   current user's home directory
/   filesystem root
```

---

## 11. Delete Files and Directories

The completed lab cleaned up the temporary resources with:

```bash
rm backups/notes-backup.txt
rmdir backups
rm -r projects
```

This demonstrated three different operations:

```text
rm file       → remove a file
rmdir dir     → remove an empty directory
rm -r dir     → recursively remove a directory and its contents
```

### Important Safety Note

Be especially careful with recursive deletion. Linux command-line deletion generally does not behave like moving something to a desktop Recycle Bin. Always verify the target path before running destructive commands.

---

## 12. Completed Hands-On Workflow

The lab successfully demonstrated the following sequence:

```text
Create Directories
       ↓
Create Files
       ↓
Write File Content
       ↓
Copy File
       ↓
Verify Copy
       ↓
Rename File
       ↓
Find Files
       ↓
Delete File
       ↓
Remove Empty Directory
       ↓
Recursively Remove Directory Tree
```

Key commands executed included:

```bash
find .
echo "Linux file management practice" > documents/notes.txt
cp documents/notes.txt backups/notes-backup.txt
ls backups
mv documents/notes.txt documents/linux-notes.txt
find . -name "*.txt"
rm backups/notes-backup.txt
rmdir backups
rm -r projects
```

---

## 13. Key Commands

| Command | Purpose |
| --- | --- |
| `pwd` | Show the current directory |
| `ls` | List files and directories |
| `cd` | Change directory |
| `mkdir` | Create a directory |
| `touch` | Create an empty file or update its timestamp |
| `cat` | Display file contents |
| `less` | View file contents interactively |
| `cp` | Copy files or directories |
| `mv` | Move or rename files/directories |
| `find` | Search for filesystem entries |
| `grep` | Search text content |
| `rm` | Remove files or directories |
| `rmdir` | Remove an empty directory |

---

## 14. 3rd-Grade Analogy — A School Building

Think of the Linux filesystem as a **big school building**.

```text
Filesystem = School
Directory  = Classroom
File       = Notebook

pwd   = Which classroom am I in?
ls    = What is in this classroom?
cd    = Walk to another classroom
mkdir = Create a new classroom
touch = Get a new notebook
cp    = Photocopy a notebook
mv    = Move or rename a notebook
find  = Find a notebook
cat   = Read the notebook
rm    = Throw the notebook away
```

---

## 15. Skills Demonstrated

This hands-on exercise demonstrates the ability to:

```text
Navigate
   ↓
Create
   ↓
Write / View
   ↓
Copy
   ↓
Move / Rename
   ↓
Search
   ↓
Delete Safely
```

These are foundational Linux skills used in system administration, cloud engineering, DevOps, scripting, containers, CI/CD, and infrastructure automation.

---

## Summary

The hands-on lab was completed successfully in WSL/Linux. Files and directories were created, populated, copied, renamed, searched, verified, and cleaned up using native Linux command-line tools.

> **Linux file management means knowing where you are and being able to safely create, view, copy, move, organize, search, and remove files and directories from the command line.**
