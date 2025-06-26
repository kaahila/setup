# My personal setup script for Windows

This is a script that I use to install all the programs I need to work on my Windows machine. It will automatically request administrator privileges to install the software.

### Quick Start

This command will download and run the script, installing the default set of development tools.

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/kaahila/setup/refs/heads/master/setup.ps1'))

```

### Quick Start with game launchers
This single command will download and run the script with the game installation option enabled
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex "& { $( (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/kaahila/setup/refs/heads/master/setup.ps1') ) } -installGames"

```

### Alternative with Ninite

[to ninite](https://ninite.com/7zip-adoptjdkx17-adoptjdkx21-chrome-greenshot-notepadplusplus-putty-pythonx3-vlc-vscode-windirstat-winrar-winscp/)
