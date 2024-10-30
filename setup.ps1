#Elevate to admin
# Get the ID and security principal of the current user account
$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole)) {
    # We are running "as Administrator" - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
    $Host.UI.RawUI.BackgroundColor = "DarkBlue"
    clear-host
} else {
    #Load the Background image
    # Define the URL and the destination path
    $url = "https://raw.githubusercontent.com/kaahila/setup/refs/heads/master/background.jpg"
    $wallpaperPath = "$env:USERPROFILE\Pictures\background.jpg"

    # Download the file
    Invoke-WebRequest -Uri $url -OutFile $wallpaperPath

    # Confirm download
    Write-Output "Background Image downloaded to $wallpaperPath"

    #Does $Profile exist?
    if (-not (Test-Path $Profile)) {
        New-Item -Path $PROFILE -Type File -Force
    }

    #Write to the profile scrip
    if (Select-String -Path $PROFILE -Pattern "oh-my-posh init pwsh" -Quiet) {
        Write-Output "oh-my-posh is already initialized in the profile script."
    } else {
        Add-Content $PROFILE ( -join ("oh-my-posh init pwsh --config '$env:POSH_THEMES_PATH\if_tea.omp.json' | Invoke-Expression"))
        Write-Output "Initialized oh-my-posh in the profile script."
    }
    
    #Set Desktop background
    Add-Type -TypeDefinition @'
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
'@
    [Wallpaper]::SetWallpaper($wallpaperPath)


    # We are not running "as Administrator" - so relaunch as administrator

    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;

    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";

    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);

    # Exit from the current, unelevated, process
    exit
}

Write-Output "Installing Programms."
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

#install git
winget install Git.Git -s winget

#winget to install java 17 and 21
winget install Microsoft.OpenJDK.21 -s winget
winget install Microsoft.OpenJDK.17 -s winget

# Reload environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine) + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

Write-Output "Environment variables reloaded."

oh-my-posh font install JetBrainsMono
