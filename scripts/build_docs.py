"""Stage the repository's documentation and build its GitHub Pages site."""

from pathlib import Path
import shutil
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "build" / "docs-source"
PUBLISHED_SUFFIXES = {".md", ".html", ".pdf", ".xlsx", ".png"}


def main() -> None:
    # Keep the docs source separate from the repository so MkDocs does not
    # publish application code, recordings, models, or build artifacts.
    if SOURCE.exists():
        shutil.rmtree(SOURCE)
    SOURCE.mkdir(parents=True)

    tracked = subprocess.check_output(
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=ROOT,
    )
    for name in tracked.decode().split("\0"):
        if not name:
            continue
        relative = Path(name)
        if relative.suffix.lower() not in PUBLISHED_SUFFIXES:
            continue
        if relative == Path("README.md"):
            relative = Path("index.md")
        source = ROOT / name
        if not source.is_file():
            continue
        destination = SOURCE / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)

    subprocess.run([sys.executable, "-m", "mkdocs", "build", "--strict"], cwd=ROOT, check=True)


if __name__ == "__main__":
    main()
