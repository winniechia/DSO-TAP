# Linux RBAC — Hands-On Access Control Lab

**Competency:** Server Administration Roles and Responsibilities — Server Admin  
**Requirement:** Demonstrate ability / experience in understanding RBAC (Role-Based Access Control).  
**Lab date:** September 29, 2026  
**Environment:** Ubuntu on WSL2, host `msi-aegis-zs2`

## Excel Competency Summary

Implemented and tested Linux role-based access control (RBAC) using users, groups, and filesystem permissions. Assigned Developer and Auditor roles, restricted a team resource to the Developers group, and verified that authorized users could access the resource while unauthorized users were denied.

## Demo Summary / Presentation Talking Points

For this competency, I implemented RBAC on Linux using users, groups, and filesystem permissions. I created Developer and Auditor groups, assigned test users to the appropriate roles, and configured a protected team directory so only members of the Developers group had access.

I then tested the policy instead of assuming it worked. Alice, a member of the Developers group, successfully created a file in the protected directory. Bob, a member of the Auditors group, received a permission-denied error. My regular `dev` account, which was not assigned the Developer role, was also denied, while administrative access through `sudo` could inspect the resource.

**RBAC model:** **User → Role/Group → Permission → Resource**

### 30-Second Demo Version

> I implemented Linux RBAC using users, groups, and filesystem permissions. I assigned Alice to the Developers role and Bob to the Auditors role, protected a team directory for Developers only, and tested the policy. Alice was allowed to create a file, while Bob and an unassigned user were denied. This demonstrated role-based access and least privilege.

## 1. Create Roles with Linux Groups

I created two groups representing different team roles:

```bash
sudo groupadd developers
sudo groupadd auditors
```

I verified them with:

```bash
getent group developers
getent group auditors
```

Observed:

```text
developers:x:1002:
auditors:x:1003:
```

## 2. Create Test Users

I created two test users:

```bash
sudo useradd -m alice
sudo useradd -m bob
```

Before role assignment:

```text
uid=1001(alice) gid=1004(alice) groups=1004(alice)
uid=1002(bob) gid=1005(bob) groups=1005(bob)
```

This established a baseline showing that neither user initially had the Developer or Auditor role.

## 3. Assign Users to Roles

I assigned Alice to Developers and Bob to Auditors:

```bash
sudo usermod -aG developers alice
sudo usermod -aG auditors bob
```

Verification with `id` showed:

```text
alice → groups=alice,developers
bob   → groups=bob,auditors
```

This implemented the mapping:

```text
Alice → Developers role
Bob   → Auditors role
```

## 4. Protect a Team Resource

I created a shared resource for the development team:

```bash
sudo mkdir -p /srv/dev-team
sudo chown root:developers /srv/dev-team
sudo chmod 770 /srv/dev-team
ls -ld /srv/dev-team
```

Observed:

```text
drwxrwx--- 2 root developers ... /srv/dev-team
```

The `770` permissions mean:

- Owner (`root`): read, write, execute
- Group (`developers`): read, write, execute
- Others: no access

## 5. Test Authorized Access

I tested the resource as Alice:

```bash
sudo -u alice touch /srv/dev-team/alice-test.txt
sudo -u alice ls -l /srv/dev-team
```

Alice successfully created:

```text
alice-test.txt
```

This confirmed that membership in the Developers role granted the required access.

## 6. Test Unauthorized Access

I tested the same resource as Bob:

```bash
sudo -u bob touch /srv/dev-team/bob-test.txt
```

Observed:

```text
Permission denied
```

A later administrative directory listing confirmed that no `bob-test.txt` file had been created.

My regular `dev` account also received `Permission denied` when attempting to list the protected directory because it was not a member of the Developers group.

## 7. Administrative Verification

I used administrative privileges to inspect the final state:

```bash
sudo ls -la /srv/dev-team
```

Observed that the protected directory contained only:

```text
-rw-r--r-- 1 alice alice ... alice-test.txt
```

Final access behavior:

| Identity | Role | Result |
| --- | --- | --- |
| Alice | Developers | Allowed |
| Bob | Auditors | Denied |
| dev | No Developer role | Denied |
| root / sudo | Administrator | Allowed |

## Skills Demonstrated

- Role-based access control concepts
- Linux user administration
- Linux group administration
- User-to-role assignment
- Filesystem ownership
- Linux permission management
- Least-privilege access
- Authorized-access testing
- Unauthorized-access testing
- Administrative verification

## Completion

This lab provides hands-on evidence of understanding and implementing RBAC. Access was granted through role/group membership rather than individual exceptions, and the resulting policy was verified with both allowed and denied access tests.
