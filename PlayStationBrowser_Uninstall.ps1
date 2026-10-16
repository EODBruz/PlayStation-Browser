#requires -Version 5.1
<#
.SYNOPSIS
    PlayStation Browser - Uninstaller / Cleanup Script
.DESCRIPTION
    Removes all files, shortcuts, and folders created by PlayStation Browser:
      - %APPDATA%\PlayStationBrowser   (app script, icon, and your saved IP in ip.txt)
      - Desktop shortcut
      - Start Menu shortcut (if one exists)
    Closes PlayStation Browser first if it is running.
    Does NOT touch Chrome or anything outside the files listed above.
#>

Write-Host ""
Write-Host "  PlayStation Browser - Uninstaller" -ForegroundColor Cyan
Write-Host "  =================================" -ForegroundColor DarkCyan
Write-Host ""

$removed = @()
$skipped = @()

function Remove-IfExists {
    param([string]$Path, [string]$Label)
    if (Test-Path $Path) {
        try {
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Host "  [REMOVED] $Label" -ForegroundColor Green
            $script:removed += $Label
        } catch {
            Write-Host "  [FAILED]  $Label - $_" -ForegroundColor Red
        }
    } else {
        Write-Host "  [SKIP]    $Label (not found)" -ForegroundColor DarkGray
        $script:skipped += $Label
    }
}

# -- 0. Close PlayStation Browser if it is running ---------------------------
try {
    $running = Get-CimInstance Win32_Process -ErrorAction SilentlyContinue |
        Where-Object {
            $_.ProcessId -ne $PID -and
            $_.Name -match '^(powershell|pwsh)\.exe$' -and
            $_.CommandLine -like '*PlayStationBrowser.ps1*'
        }
    if ($running) {
        foreach ($proc in $running) {
            try {
                Stop-Process -Id $proc.ProcessId -Force -ErrorAction Stop
                Write-Host "  [CLOSED]  Running PlayStation Browser (PID $($proc.ProcessId))" -ForegroundColor Yellow
            } catch {}
        }
        Start-Sleep -Milliseconds 600
    } else {
        Write-Host "  [SKIP]    PlayStation Browser is not running" -ForegroundColor DarkGray
    }
} catch {}

# -- 1. AppData install folder (script + icon + saved IP) --------------------
#   %APPDATA%\PlayStationBrowser\PlayStationBrowser.ps1
#   %APPDATA%\PlayStationBrowser\PlayStationBrowser_<hash>.ico
#   %APPDATA%\PlayStationBrowser\ip.txt
Remove-IfExists "$env:APPDATA\PlayStationBrowser" "AppData folder (%APPDATA%\PlayStationBrowser)"

# -- 2. Desktop shortcut ------------------------------------------------------
$desktopShortcut = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('Desktop'),
    'PlayStation Browser.lnk'
)
Remove-IfExists $desktopShortcut "Desktop shortcut"

# -- 3. Start Menu shortcut ---------------------------------------------------

# Flat .lnk directly under Programs\
$startMenuShortcut = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('StartMenu'),
    'Programs',
    'PlayStation Browser.lnk'
)
Remove-IfExists $startMenuShortcut "Start Menu shortcut"

# Also catch if it was ever installed into its own subfolder
$startMenuDir = [System.IO.Path]::Combine(
    [Environment]::GetFolderPath('StartMenu'),
    'Programs',
    'PlayStation Browser'
)
Remove-IfExists $startMenuDir "Start Menu folder (if exists)"

# -- Refresh Explorer so the desktop icon disappears right away --------------
try {
    Add-Type -Name Shell -Namespace PsbUninstall -MemberDefinition '
    [DllImport("shell32.dll")]
    public static extern void SHChangeNotify(int wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);
    ' -ErrorAction SilentlyContinue
    [PsbUninstall.Shell]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)
} catch {}

# -- Summary ------------------------------------------------------------------
Write-Host ""
Write-Host "  ----------------------------------------" -ForegroundColor DarkCyan
Write-Host "  Done! $($removed.Count) item(s) removed, $($skipped.Count) already absent." -ForegroundColor Cyan
Write-Host ""

if ($removed.Count -eq 0) {
    Write-Host "  Nothing was found - PlayStation Browser may not have been installed on this machine." -ForegroundColor Yellow
}

Write-Host "  Press any key to exit..." -ForegroundColor DarkGray
try {
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} catch {
    Start-Sleep -Seconds 3
}
