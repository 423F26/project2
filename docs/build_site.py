"""Stage repository documentation and build the GitHub Pages site."""

from pathlib import Path
import shutil
import subprocess
import sys


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "build" / "docs-source"
PUBLISHED_SUFFIXES = {
    ".md", ".html", ".pdf", ".xlsx", ".png",
    ".kicad_sch", ".kicad_pcb", ".step", ".stp",
}


def main() -> None:
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
            continue
        source = ROOT / relative
        if not source.is_file():
            continue
        destination = SOURCE / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)
        if relative in {
            Path("docs/user/getting-started.md"),
            Path("docs/user/lv2-plugins.md"),
        }:
            content = destination.read_text()
            destination.write_text(content.replace("../../README.md", "../../index.md"))

    shutil.copy2(ROOT / "README.md", SOURCE / "index.md")
    subprocess.run(
        [sys.executable, "-m", "mkdocs", "build", "--strict", "-f", "docs/mkdocs.yml"],
        cwd=ROOT,
        check=True,
    )


if __name__ == "__main__":
    main()
