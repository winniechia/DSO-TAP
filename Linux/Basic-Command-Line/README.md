# Basic Linux Command Line — Hands-On Demo

## Objective

This lab demonstrates a basic understanding of the Linux command line, including how to read the shell prompt, execute commands, navigate the filesystem, inspect the system, get help, and combine commands.

## 1. Understand the Command Prompt

A Linux terminal may display:

```text
winnie@linux-server:~$
```

```text
winnie        = current user
linux-server  = hostname
~             = home directory
$             = regular-user prompt
```

A root shell commonly uses `#` instead of `$`.

## 2. Basic Commands

```bash
whoami
hostname
pwd
date
```

These answer:

```text
whoami   → Who am I?
hostname → Which computer am I using?
pwd      → Where am I?
date     → What is the system date and time?
```

## 3. Command Syntax

A common Linux command structure is:

```text
command [options] [arguments]
```

Example:

```bash
ls -l /etc
```

```text
ls   = command
-l   = option
/etc = argument
```

Think of it as:

> **ACTION + HOW + WHAT**

## 4. Navigate Linux

```bash
pwd
ls
cd /tmp
pwd
cd ~
cd ..
```

Important locations:

```text
/   filesystem root
~   home directory
.   current directory
..  parent directory
```

## 5. Inspect the System

```bash
uname -a
cat /etc/os-release
df -h
free -h
```

These help identify the operating system, Linux distribution, filesystem usage, and memory usage.

## 6. Understand Exit Status

A command can produce output, an error, or no visible output. No visible output does not necessarily mean failure.

In common shells such as Bash, check the previous command's exit status with:

```bash
echo $?
```

Typically:

```text
0        = success
non-zero = an error or another non-success status
```

Exit status is important in shell scripting, automation, and CI/CD.

## 7. Get Help

```bash
man ls
ls --help
```

A useful Linux skill is knowing how to find documentation rather than trying to memorize every command option.

## 8. Command History

```bash
history
```

Common interactive shortcuts include:

```text
Up Arrow  → recall previous commands
Ctrl + R  → search command history
```

## 9. Clear the Terminal

```bash
clear
```

A commonly supported shortcut is:

```text
Ctrl + L
```

## 10. Pipes

A pipe sends the output of one command to another command.

```bash
history | tail
```

Conceptually:

```text
history → output → | → tail → final lines
```

Another example:

```bash
ls -la | less
```

## 11. Output Redirection

Write output to a file:

```bash
date > date.txt
```

Append output:

```bash
whoami >> date.txt
```

```text
>   write/replace output
>>  append output
```

Use `>` carefully because it can overwrite an existing file.

## 12. Interrupt a Running Command

A common terminal shortcut for interrupting a foreground command is:

```text
Ctrl + C
```

## 13. Core Commands

| Command | Purpose |
| --- | --- |
| `whoami` | Show current username |
| `hostname` | Show system hostname |
| `pwd` | Show current directory |
| `ls` | List files and directories |
| `cd` | Change directory |
| `date` | Show system date/time |
| `uname` | Show system/kernel information |
| `df -h` | Show filesystem disk usage |
| `free -h` | Show memory information where available |
| `history` | Show command history |
| `man` | Read manual pages |
| `clear` | Clear terminal display |

## 14. 3rd-Grade Analogy — Talking to a Robot

Think of the Linux command line as talking to a very literal robot.

```bash
pwd
```

means: **Tell me where I am.**

```bash
ls
```

means: **Show me what is around me.**

```bash
cd /tmp
```

means: **Go to `/tmp`.**

The robot follows instructions precisely. Learning Linux means learning to give the computer clear and precise commands.

## 15. Skills Demonstrated

```text
Open Terminal
     ↓
Understand Prompt
     ↓
Execute Commands
     ↓
Navigate
     ↓
Inspect System
     ↓
Read Output and Errors
     ↓
Check Exit Status
     ↓
Use Help
     ↓
Use Pipes and Redirection
```

These skills provide a foundation for Linux administration, cloud engineering, DevOps, shell scripting, containers, CI/CD, and infrastructure automation.

## One-Sentence Summary

> **The Linux command line is a text-based interface for communicating with the operating system by entering commands, options, and arguments.**
