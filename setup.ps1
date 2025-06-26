# To run this script and install the game clients, execute it with the -installGames switch:
# .\your_script_name.ps1 -installGames
#
# To run without installing games, simply execute the script:
# .\your_script_name.ps1

[CmdletBinding()]
param (
    [Switch]$installGames
)

# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " (Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    Clear-Host
}
else {
    # We are not running "as Administrator" - so relaunch as administrator
    
    # --- Set Desktop Background ---
    # Load the Background image
    # Define the URL and the destination path
    $url = "https://raw.githubusercontent.com/kaahila/setup/refs/heads/master/background.jpg"
    $picturesPath = [Environment]::GetFolderPath('MyPictures')
    $wallpaperPath = Join-Path -Path $picturesPath -ChildPath "background.jpg"

    # Create the Pictures directory if it doesn't exist
    if (-not (Test-Path -Path $picturesPath)) {
        New-Item -ItemType Directory -Path $picturesPath | Out-Null
    }

    # Download the file
    try {
        Invoke-WebRequest -Uri $url -OutFile $wallpaperPath -ErrorAction Stop
        Write-Output "Background Image downloaded to $wallpaperPath"

        # Set Desktop background using C# code within PowerShell
        Add-Type -TypeDefinition @"
        using System.Runtime.InteropServices;
        public class Wallpaper {
            public const uint SPI_SETDESKWALLPAPER = 0x0014;
            public const uint SPIF_UPDATEINIFILE = 0x01;
            public const uint SPIF_SENDWININICHANGE = 0x02;
            [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
            private static extern int SystemParametersInfo (uint uAction, uint uParam, string lpvParam, uint fuWinIni);
            public static void SetWallpaper (string path) {
                SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE);
            }
        }
"@
        [Wallpaper]::SetWallpaper($wallpaperPath)
        Write-Output "Desktop wallpaper has been set."
    }
    catch {
        Write-Warning "Failed to download or set wallpaper. Error: $($_.Exception.Message)"
    }
    
    # --- Relaunch with Elevation ---
    # Create a new process object that starts PowerShell
    $newProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"

    # Pass the current script path and any parameters to the new process
    $arguments = "-File `"$($myInvocation.MyCommand.Definition)`""
    if ($installGames) {
        $arguments += " -installGames"
    }
    $newProcess.Arguments = $arguments

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas"

    # Start the new process
    try {
        [System.Diagnostics.Process]::Start($newProcess)
    }
    catch {
        Write-Error "Failed to relaunch script with administrator privileges. Please run the script as an Administrator manually."
    }
    

    # Exit from the current, unelevated, process
    exit
}

# --- Software Installation ---
Write-Output "Starting software installation."

# Winget to install dbeaver
winget install dbeaver.dbeaver -s winget --accept-package-agreements --accept-source-agreements

# Winget to install Brave
winget install Brave.Brave -s winget --accept-package-agreements --accept-source-agreements

# winget to install 7zip
winget install 7zip.7zip -s winget --accept-package-agreements --accept-source-agreements

# winget to install putty
winget install putty.putty -s winget --accept-package-agreements --accept-source-agreements

# winget to install notepad++
winget install notepadplusplus.notepadplusplus -s winget --accept-package-agreements --accept-source-agreements

# winget to install vscode
winget install microsoft.vscode -s winget --accept-package-agreements --accept-source-agreements

# winget to install python 3.13.0
winget install Python.Python.3 -s winget --accept-package-agreements --accept-source-agreements

# winget to install vlc
winget install VideoLAN.VLC -s winget --accept-package-agreements --accept-source-agreements

# winget to install winscp
winget install WinSCP.WinSCP -s winget --accept-package-agreements --accept-source-agreements

# winget to install windirstat
winget install WinDirStat.WinDirStat -s winget --accept-package-agreements --accept-source-agreements

# winget to install winrar
winget install RARLab.WinRAR -s winget --accept-package-agreements --accept-source-agreements

# install git
winget install Git.Git -s winget --accept-package-agreements --accept-source-agreements

# winget to install java 17 and 21
winget install Microsoft.OpenJDK.21 -s winget --accept-package-agreements --accept-source-agreements
winget install Microsoft.OpenJDK.17 -s winget --accept-package-agreements --accept-source-agreements


# --- Optional Game Client Installation ---
if ($installGames) {
    Write-Output "Installing Game Clients as requested."
    
    # Install Steam
    winget install Valve.Steam -s winget --accept-package-agreements --accept-source-agreements

    # Install Riot Client
    winget install RiotGames.RiotClient -s winget --accept-package-agreements --accept-source-agreements
    
    # Install Ubisoft Connect (Uplay)
    winget install Ubisoft.Connect -s winget --accept-package-agreements --accept-source-agreements

    # Install Playnite
    winget install Playnite.Playnite -s winget --accept-package-agreements --accept-source-agreements

    # Install BattleNet
    winget install Blizzard.BattleNet -s winget --accept-package-agreements --accept-source-agreements
} else {
    Write-Output "Skipping game client installation. To install them, run the script with the '-installGames' switch."
}


# --- Finalization ---
Write-Output "Reloading environment variables to apply changes."
# Reload environment variables to make sure new paths (like for Git, Java, Python) are available
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

Write-Output "Script finished. All selected programs are installed."
