# PlayStation Browser

A tiny Windows app that opens a saved IP address plus a port you type, in a Chrome app window.

Type the port, press **Enter** (or click **GO**), and it opens `http://IP:PORT`.

Script by [@EODBruz](https://x.com/EODBruz)

## Features

- Saves your IP in a text file in AppData, so you only type the port each time
- Opens the page in a clean Chrome app-mode window (no tabs or address bar)
- Falls back to Edge or Brave if Chrome is not installed
- Checks the IP and port before opening and shows errors in the window
- Creates a desktop shortcut with the PlayStation icon
- One single script, no extra files or dependencies

## Requirements

- Windows 10 or 11
- PowerShell 5.1 or newer (built into Windows)
- Google Chrome (recommended)

## Install

**Option 1 - Download**

1. Download `PlayStationBrowser.ps1` from this repo.
2. Right-click the file and choose **Run with PowerShell**.

If Windows shows a security warning, right-click the file, open **Properties**, tick **Unblock**, click **Apply**, then run it again.

**Option 2 - Run straight from GitHub**

Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/EODBruz/PlayStation-Browser/main/PlayStationBrowser.ps1 | iex
```

On first run the app copies itself to `C:\Users\<your name>\AppData\Roaming\PlayStationBrowser` (the same place as `%APPDATA%\PlayStationBrowser`) and puts a **PlayStation Browser** shortcut on your desktop. Use that shortcut from then on.

## How to use

1. Open PlayStation Browser.
2. Enter the IP address (it is remembered after the first time).
3. Enter the port number.
4. Press **Enter** or click **GO**.

For example, IP `192.168.0.1` and port `8080` opens `http://192.168.0.1:8080`.

You can also edit the saved IP directly in `C:\Users\<your name>\AppData\Roaming\PlayStationBrowser\ip.txt`.

## Where files are stored

Everything lives in `C:\Users\<your name>\AppData\Roaming\PlayStationBrowser` (that is where `%APPDATA%` points).

To open it quickly, press **Win + R**, type `%APPDATA%\PlayStationBrowser` and press Enter.


| File | What it is |
| --- | --- |
| `PlayStationBrowser.ps1` | The installed copy of the app |
| `PlayStationBrowser_<hash>.ico` | The shortcut icon |
| `ip.txt` | Your saved IP address |

The only other thing it creates is the desktop shortcut.

## Uninstall

Download `PlayStationBrowser_Uninstall.ps1` and run it with PowerShell. It closes the app if it is running, then removes the `AppData\Roaming\PlayStationBrowser` folder (including your saved IP), the desktop shortcut, and any Start Menu shortcut.

Or run it straight from GitHub:

```powershell
irm https://raw.githubusercontent.com/EODBruz/PlayStation-Browser/main/PlayStationBrowser_Uninstall.ps1 | iex
```

## Follow

[@EODBruz on X](https://x.com/EODBruz)
