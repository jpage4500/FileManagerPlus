<div align="center">

<img src="icon.png" width="128" alt="File Manager+ icon">

# File Manager+

**A modern, fast, developer-friendly file manager for macOS, Windows and Linux.**

[![Download](https://img.shields.io/badge/Download-latest%20release-0A6CFF?style=for-the-badge)](https://github.com/jpage4500/FileManagerPlus/releases/latest)
&nbsp;
![macOS](https://img.shields.io/badge/macOS-000?style=for-the-badge&logo=apple&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

<br>

<img src="resources/screenshot-list.png" width="900" alt="File Manager+ main window">

</div>

---

## Why you might like it

There's **plenty** of file managers out there, including one built into your OS (macOS Finder, Windows File Explorer). I've tried several and the best one were either pricey or required a subscription model which adds up and is hard to justify. The free/open source ones never really worked the way I wanted them to - many times they have an outdated UI or have just been around for so long they've gotten overly complex to use.

I wanted a File Manager that I will actually use every day. So, it needs to be FAST, keyboard friendly and have a modern UI. I'm also a developer so there's several developer friendly features that I wanted. But, they shouldn't get in the way for non-developers or slow down the app.

I've been a developer for 20+ years. I am passionate about the products I work on and work to make them the best in class any way that I can. AI has undoubtedly changed the programming landscape forever and I'm embracing it head-on. I know what I want in an app and AI allows me to get there 1000 times faster than doing it myself. While anyone can write an app today, I know what features should look like - how to keep the code from getting unmanageable and generally won't release any AI SLOP. Software can work differently for different people so maintaining it is critical for making it last.

---

## Features

### 🗂 Browse

| | |
|---|---|
| **Tabs** | Open as many as you like (⌘T), reorder them by dragging, jump with ⌘1–9, and pick up where you left off after a restart |
| **Expand in place** | Click a folder's chevron to unfold it inside the list — compare two subfolders without losing your place |
| **Sort & resize** | Sort by Name, Size or Date Modified; folders stay on top, numbers sort naturally (`file2` before `file10`) |
| **Icon view** | Real thumbnails for images and PDFs, with a zoom slider |
| **Filter as you type** | ⌘F narrows the current folder instantly |
| **Type to select** | Start typing a name in the list and it jumps there |
| **Go to Folder** | ⇧⌘G — type a path, Tab completes it, matching subfolders are listed as you go |
| **Hidden files** | ⇧⌘. toggles them |

### ✏️ Manage

| | |
|---|---|
| **The usual operations** | New folder, new file, rename in place (F2), copy / cut / paste, duplicate, move to trash, delete |
| **Progress you can cancel** | Long copies and moves report in the status bar and stop cleanly, removing whatever they had half-written |
| **Conflict handling** | Replace / Keep Both / Skip / Stop, with "apply to all" and both files shown side by side so you can tell them apart |
| **Drag and drop** | Onto a folder, onto another tab, into the sidebar, or out to any other app. Move is the default — hold ⌥ to copy, and the ghost tells you which |
| **Get Info** | ⌘I — size, kind, dates, a permissions grid you can edit (checkboxes or the octal field), owner and group, and the macOS lock flag |
| **Open With** | Right-click for every app that can open the file, "Other…" for anything else on the machine, and Change All to set the default for that file type |

### 👁 Preview

| | |
|---|---|
| **Press Space** | Images, PDFs and text/code, in a window of its own |
| **Select and copy** | Text in the preview is real text — select it, copy it |
| **Arrow through** | ← / → step to the next file in the folder without closing the preview |

### 🌐 Connect

| | |
|---|---|
| **Connect to Server** | ⌘K — SMB, AFP, NFS and WebDAV |
| **Share picker** | Type just a server name and pick from the shares it offers |
| **Keychain** | Passwords go to your system's own secret store, never into the app's settings |
| **Reconnect in a click** | Save a server to Favorites; clicking it mounts the share again |
| **Locations** | Home, mounted drives, shares, iCloud Drive, Google Drive and other cloud folders, the network and the Trash — updating live as drives come and go, with an eject button on each row |

### ⭐️ Make it yours

| | |
|---|---|
| **Favorites** | Drag folders in from the list or the breadcrumb, rename them in place, and organize them into collapsible groups |
| **Per-folder views** | Pin a view (and its icon size) to a specific folder — your Photos folder can open as icons while everything else stays a list |
| **Sidebar** | Resize it, or hide it entirely with ⌥⌘S |
| **Terminal** | ⌥⌘T opens the current folder in your terminal of choice |

---

## Screenshots

<div align="center">

| Icon view with thumbnails | Quick preview |
|---|---|
| <img src="resources/screenshot-icons.png" width="420" alt="Icon view"> | <img src="resources/screenshot-preview.png" width="420" alt="Quick preview"> |
| **Get Info** | **Connect to Server** |
| <img src="resources/screenshot-info.png" width="420" alt="Get Info panel"> | <img src="resources/screenshot-connect.png" width="420" alt="Connect to Server dialog"> |

</div>

---

## Install

Grab the build for your platform from the
**[latest release](https://github.com/jpage4500/FileManagerPlus/releases/latest)**. Everything the app
needs is bundled — there's no Java to install first — and it updates itself when a new version
ships.

<details>
<summary><b>macOS</b></summary>

Download the macOS build for your chip (Apple Silicon or Intel), open it, and drag **File Manager+**
to Applications.

The app isn't notarized yet, so the first launch needs a nudge: **right-click the app → Open**, then
confirm. macOS remembers the choice and normal double-clicks work from then on.

</details>

<details>
<summary><b>Windows</b></summary>

Download the Windows build and run it. SmartScreen may warn about an unrecognized publisher — choose
**More info → Run anyway**.

</details>

<details>
<summary><b>Linux</b></summary>

Download the Linux build for your architecture (x64 or arm64) and run the launcher. Depending on
your distribution you may need to mark it executable first:

```bash
chmod +x <downloaded-file>
```

</details>

Settings, logs, thumbnails and per-folder view preferences all live in `~/.file-manager+/` — delete
that folder to reset the app to a clean slate.

---

## Keyboard shortcuts

Shortcuts use ⌘ on macOS and **Ctrl** on Windows/Linux.

| | | | |
|---|---|---|---|
| **New Tab** | ⌘T | **Copy / Cut / Paste** | ⌘C / ⌘X / ⌘V |
| **Close Tab** | ⌘W | **Select All** | ⌘A |
| **Switch Tab** | ⌘1–9 | **Rename** | F2 |
| **Back / Forward** | ⌘[ / ⌘] | **Duplicate** | ⌘D |
| **Enclosing Folder** | ⌘↑ | **Move to Trash** | ⌘⌫ |
| **Go to Folder…** | ⇧⌘G | **Delete Immediately** | ⌥⌘⌫ |
| **Connect to Server…** | ⌘K | **New Folder** | ⇧⌘N |
| **Quick preview** | Space | **Get Info** | ⌘I |
| **Filter** | ⌘F | **Reveal in Finder** | ⇧⌘R |
| **Views (icons/list/columns/gallery)** | ⌥1 – ⌥4 | **Open in Terminal** | ⌥⌘T |
| **Show/Hide Sidebar** | ⌥⌘S | **Show/Hide Hidden Files** | ⇧⌘. |
| **Refresh** | ⌘R | **Settings** | ⌘, |

---

## Roadmap

- **Column and Gallery views** — the buttons exist, the views don't
- **Undo** for move, rename and trash
- **Recursive search** — the filter matches the current folder only
- **Dark mode**

