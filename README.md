# LocalImageConverter

Convert images to ICO files locally with a simple Windows Explorer context menu shortcut.

## Prerequisites

- Windows with Python 3.11+ installed and available on `PATH`
- `pip install -r requirements.txt` (installs Pillow)

## Installation

1. Clone or download this repository to a stable location.
2. Open PowerShell in the repository folder.
3. Run `scripts\install-context-menu.ps1` (an icon is optional; see Notes).
4. Restart File Explorer if the new menu does not appear right away.

This creates a new context menu entry for image files:

```
LocalImageConverter
└── Convert to ICO…
```

## Usage

1. Right-click any image file (e.g., PNG, JPG, BMP) in Explorer.
2. Choose **LocalImageConverter → Convert to ICO…**.
3. Pick a destination in the save dialog. The converter writes the ICO file immediately.

## Uninstall

If you want to remove the menu entry later, run:

```
scripts\uninstall-context-menu.ps1
```

## How it works

- `scripts/install-context-menu.ps1` registers a submenu under Explorer’s image file associations and points to `scripts/run-converter.ps1`.
- `scripts/run-converter.ps1` launches `app/local_image_converter.py`, passing in the selected image path from Explorer.
- `app/local_image_converter.py` opens a save dialog (via Tkinter) and converts the image to ICO using Pillow.

## Notes

- The converter keeps transparency when present in the source file.
- If you move the repository, rerun the install script so the registry entry points to the new path.
- This repository ships without any binary icon. You can optionally place a custom `app/icon.ico` before running the install script. If the file is missing, the installer skips the icon entry so no binary assets are required in the repo.
- The installer prefers `pythonw.exe` to avoid flashing a console window. If unavailable, it falls back to `python.exe`.
