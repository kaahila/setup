#Winget to install dbeaver
winget install dbeaver.dbeaver -s winget

#Winget to install oh-my-posh
winget install JanDeDobbeleer.OhMyPosh -s winget

#Winget zen browser
winget install Zen-Team.Zen-Browser.Optimized -s winget

#winget to install 7zip
winget install 7zip.7zip -s winget

#winget to install putty
winget install putty.putty -s winget

#winget to install notepad++
winget install notepadplusplus.notepadplusplus -s winget

#winget to install vscode
winget install microsoft.vscode -s winget

#winget to install python 3.13.0
winget install Python.Python.3.13 -s winget

#winget to install vlc
winget install VideoLAN.VLC -s winget

#winget to install winscp
winget install WinSCP.WinSCP -s winget

#winget to install windirstat
winget install WinDirStat.WinDirStat -s winget

#winget to install winrar
winget install RARLab.WinRAR -s winget

#winget to install java 17 and 21
winget install adoptopenjdk.openjdk17 -s winget
winget install adoptopenjdk.openjdk21 -s winget

#Does $Profile exist?
if (-not (Test-Path $Profile)) {
    New-Item -Path $PROFILE -Type File -Force
}

#Clear the profile script
Clear-Content $PROFILE

#Write to the profile scrip
Add-Content $PROFILE "oh-my-posh init pwsh --config 'C:\Users\drdoo\AppData\Local\Programs\oh-my-posh\themes\if_tea.omp.json' | Invoke-Expression"

