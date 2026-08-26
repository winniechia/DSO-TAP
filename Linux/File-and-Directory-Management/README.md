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

## 1. Check the Current Directory

Run:

```bash
pwd
```

`pwd` means **print working directory**. It tells you where you currently are in the filesystem.

Example:

```text
/home/winnie
```

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

Create a directory:

```bash
mkdir linux-file-demo
```

Enter it:

```bash
cd linux-file-demo
```

Verify your location:

```bash
pwd
```

---

## 4. Create Directories

Create several directories:

```bash
mkdir documents
mkdir scripts
mkdir backups
```

Verify:

```bash
ls
```

Expected structure:

```text
backups  documents  scripts
```

You can create nested directories with `mkdir -p`:

```bash
mkdir -p projects/demo/config
```

---

## 5. Create Files

Create empty files with `touch`:

```bash
touch documents/notes.txt
touch scripts/hello.sh
touch README.md
```

View the project structure:

```bash
find .
```

Conceptually:

```text
linux-file-demo/
│
├── README.md
├── documents/
│   └── notes.txt
├── scripts/
│   └── hello.sh
├── backups/
└── projects/
    └── demo/
        └── config/
```

---

## 6. Add and View File Content

Add text to a file:

```bash
echo "Linux file management practice" > documents/notes.txt
```

Display the file:

```bash
cat documents/notes.txt
```

Other useful commands for viewing files include:

```bash
less documents/notes.txt
head documents/notes.txt
tail documents/notes.txt
```

---

## 7. Copy a File

Copy the notes file into the backup directory:

```bash
cp documents/notes.txt backups/notes-backup.txt
```

Verify:

```bash
ls backups
```

Think of `cp` as:

> **Make a photocopy.**

The original file remains in its original location.

---

## 8. Move and Rename Files

Move the README file into the documents directory:

```bash
mv README.md documents/
```

Rename the notes file:

```bash
mv documents/notes.txt documents/linux-notes.txt
```

The `mv` command can therefore be used for both:

- Moving a file or directory
- Renaming a file or directory

Think of `mv` as:

> **Pick something up and put it somewhere else.**

---

## 9. Search for Files

Find all `.txt` files under the current directory:

```bash
find . -name "*.txt"
```

Example output:

```text
./documents/linux-notes.txt
./backups/notes-backup.txt
```

Search inside a file for text:

```bash
grep "Linux" documents/linux-notes.txt
```

An easy distinction is:

```text
find = Where is the file?

grep = Where is the text?
```

---

## 10. Relative and Absolute Paths

An **absolute path** begins from the filesystem root `/` and describes the complete location.

Example:

```text
/home/winnie/linux-file-demo/documents/linux-notes.txt
```

A **relative path** describes a location relative to the directory you are currently in.

Example:

```text
documents/linux-notes.txt
```

Useful path shortcuts include:

```text
.   current directory
..  parent directory
~   current user's home directory
/   filesystem root
```

---

## 11. Delete Files and Directories

Delete a file:

```bash
rm backups/notes-backup.txt
```

Delete an empty directory:

```bash
rmdir backups
```

Delete a directory and its contents recursively:

```bash
rm -r projects
```

### Important Safety Note

Be careful with `rm`, especially recursive deletion.

Linux command-line deletion generally does not behave like moving a file into a desktop Recycle Bin. Verify the path before executing destructive commands.

---

## 12. Key Commands

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

## 13. 3rd-Grade Analogy — A School Building

Think of the Linux filesystem as a **big school building**.

```text
Filesystem = School

Directory = Classroom

File = Notebook

pwd = Which classroom am I in?

ls = What is in this classroom?

cd = Walk to another classroom

mkdir = Create a new classroom

touch = Get a new notebook

cp = Photocopy a notebook

mv = Move or rename a notebook

find = Find a notebook

cat = Read the notebook

rm = Throw the notebook away
```

This gives us a simple mental model for navigating and organizing Linux.

---

## 14. Skills Demonstrated

After completing this lab, you have demonstrated the ability to:

```text
Navigate
   ↓
Create
   ↓
View
   ↓
Copy
   ↓
Move / Rename
   ↓
Search
   ↓
Delete Safely
```

These file and directory operations are foundational Linux skills used in system administration, cloud engineering, DevOps, scripting, containers, CI/CD, and infrastructure automation.

---

## One-Sentence Summary

> **Linux file management means knowing where you are and being able to safely create, view, copy, move, organize, search, and remove files and directories from the command line.**
