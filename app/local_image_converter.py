"""Local Image Converter.

Provides a small GUI workflow for converting a single image file to ICO
format. Intended to be invoked from a Windows Explorer context menu
entry that passes the selected file path to this script.
"""
from __future__ import annotations

import argparse
from pathlib import Path
import sys
import tkinter as tk
from tkinter import filedialog, messagebox

from PIL import Image


def convert_to_ico(source_path: Path, destination_path: Path) -> None:
    """Convert an image to ICO format.

    Args:
        source_path: Source image path.
        destination_path: Output ICO path.

    Raises:
        FileNotFoundError: If the source file is missing.
        OSError: If Pillow encounters an error reading or writing files.
    """
    if not source_path.exists():
        raise FileNotFoundError(f"Source file not found: {source_path}")

    with Image.open(source_path) as image:
        if image.mode not in ("RGBA", "RGB"):
            image = image.convert("RGBA")
        destination_path.parent.mkdir(parents=True, exist_ok=True)
        image.save(destination_path, format="ICO")


def convert_to_png(source_path: Path, destination_path: Path) -> None:
    """Convert an image to PNG format.

    Args:
        source_path: Source image path.
        destination_path: Output PNG path.

    Raises:
        FileNotFoundError: If the source file is missing.
        OSError: If Pillow encounters an error reading or writing files.
    """
    if not source_path.exists():
        raise FileNotFoundError(f"Source file not found: {source_path}")

    with Image.open(source_path) as image:
        if image.mode not in ("RGBA", "RGB"):
            image = image.convert("RGBA")
        destination_path.parent.mkdir(parents=True, exist_ok=True)
        image.save(destination_path, format="PNG")


def select_destination(initial_path: Path) -> Path | None:
    """Open a save dialog and return the selected output path."""
    root = tk.Tk()
    root.withdraw()

    # Determine target format based on source file extension
    source_ext = initial_path.suffix.lower()
    if source_ext == ".ico":
        # Convert ICO to PNG
        default_name = initial_path.with_suffix(".png").name
        title = "Save as PNG"
        filetypes = [("PNG files", "*.png"), ("All files", "*.*")]
        default_ext = ".png"
    elif source_ext == ".webp":
        # Convert WebP to PNG
        default_name = initial_path.with_suffix(".png").name
        title = "Save as PNG"
        filetypes = [("PNG files", "*.png"), ("All files", "*.*")]
        default_ext = ".png"
    else:
        # Convert other formats to ICO
        default_name = initial_path.with_suffix(".ico").name
        title = "Save as ICO"
        filetypes = [("ICO files", "*.ico"), ("All files", "*.*")]
        default_ext = ".ico"

    chosen = filedialog.asksaveasfilename(
        title=title,
        initialdir=str(initial_path.parent),
        initialfile=default_name,
        defaultextension=default_ext,
        filetypes=filetypes,
    )
    root.destroy()

    if not chosen:
        return None
    return Path(chosen)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Convert an image to ICO format.",
    )
    parser.add_argument(
        "source",
        type=Path,
        help="Path to the image file passed from Explorer.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])

    try:
        destination = select_destination(args.source)
        if destination is None:
            return 0

        # Determine which conversion to perform based on source file extension
        source_ext = args.source.suffix.lower()
        dest_ext = destination.suffix.lower()
        
        if source_ext == ".ico" and dest_ext == ".png":
            convert_to_png(args.source, destination)
            conversion_type = "PNG"
        elif source_ext == ".webp" and dest_ext == ".png":
            convert_to_png(args.source, destination)
            conversion_type = "PNG"
        elif source_ext not in [".ico", ".webp"] and dest_ext == ".ico":
            convert_to_ico(args.source, destination)
            conversion_type = "ICO"
        else:
            # Fallback - try to convert based on destination extension
            if dest_ext == ".ico":
                convert_to_ico(args.source, destination)
                conversion_type = "ICO"
            elif dest_ext == ".png":
                convert_to_png(args.source, destination)
                conversion_type = "PNG"
            else:
                raise ValueError(f"Unsupported conversion: {source_ext} to {dest_ext}")

        messagebox.showinfo(
            "Conversion complete",
            f"Saved {conversion_type} to:\n{destination}",
        )
        return 0
    except Exception as exc:  # noqa: BLE001 - user-friendly popup
        messagebox.showerror("Conversion failed", str(exc))
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
