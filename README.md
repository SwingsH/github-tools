# github-tools
A command-line tool that makes git easier to use with GitHub. ( e.g: Powershell script to batch update multiple git repos )

### 1. update_all.sh batch update multiple git repos from one organization

- To install `jq`, a lightweight and flexible command-line JSON processor, you can follow these steps depending on your operating system:

#### On Ubuntu/Debian-based Linux:
```bash
sudo apt-get update
sudo apt-get install jq
```

#### On CentOS/RHEL-based Linux:
```bash
sudo yum install epel-release
sudo yum install jq
```

#### On macOS (using Homebrew):
```bash
brew install jq
```

#### On Windows:
You can download a precompiled binary from the [official jq website](https://stedolan.github.io/jq/download/) or use a package manager like `choco`:

- Windows : Rename and Place the Executable: Rename the downloaded file to jq.exe. Move jq.exe to a directory that is included in your system's PATH. You can place it in a folder like C:\Program Files\jq\ or directly in a system folder like C:\Windows\System32\.

```bash
choco install jq
```

Alternatively, if you're using Windows Subsystem for Linux (WSL), you can follow the Linux installation steps mentioned above.

#### On Arch Linux:
```bash
sudo pacman -S jq
```

#### To verify the installation:
```bash
jq --version
```

This command should output the installed version of `jq`.
