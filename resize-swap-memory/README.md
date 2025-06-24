# Ubuntu Swap Memory Management

## What is Swap?

Swap is virtual memory on Linux systems. When the physical RAM is fully utilized, inactive memory pages are moved to the swap space. This mechanism helps maintain system stability and prevents crashes during high memory pressure. However, swap is slower than RAM because it resides on disk.

---

## Why Resize Swap?

* To handle increased memory demands.
* Improve stability for resource-intensive applications (databases, containers, virtual machines, etc.).
* Optimize disk usage by adjusting swap size based on system needs.

---
## Prerequisites

* Root or sudo privileges.
* Ensure sufficient disk space before creating a large swap file.

---

## Usage

1. Run the script as root:

```bash
sudo ./swap_resize.sh
```

2. Follow the on-screen instructions to set the new swap size.

---

## Warnings

* Avoid using extremely large swap files unless necessary.

* Always validate on test environments before applying changes to production servers.
