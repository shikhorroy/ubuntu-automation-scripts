# Ubuntu Automation Scripts

Automation scripts to **install** and **uninstall** popular developer tools, utilities, and environments on **Ubuntu 24.04 LTS** or later.

> 📦 Run any script directly to configure your system with minimal manual steps.

---

## 📁 Directory Structure

```
ubuntu-automation-scripts/
├── app-name/
│   ├── install.sh
│   └── un-install.sh
└── README.md
```

Each `app-name/` folder contains installation and uninstallation scripts for a specific tool or application.

---

## 🚀 Getting Started

### 1️⃣ Clone This Repository

```bash
git clone https://github.com/shikhorroy/ubuntu-automation-scripts.git
cd ubuntu-automation-scripts
```

### 2️⃣ Make Scripts Executable

```bash
chmod +x */*.sh
```

### 3️⃣ Run Scripts

#### ✅ Install avro:

```bash
cd avro
./install.sh
```

#### ❌ Uninstall avro:

```bash
cd avro
./un-install.sh
```

---

## ⚖️ License

[MIT License](LICENSE)

---

> Maintained by [Shikhor Kumer Roy](https://github.com/shikhorroy)

