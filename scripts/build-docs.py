"""Build documentation with each page's last Git revision date."""

from __future__ import annotations

from datetime import datetime, timedelta, timezone
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile


ROOT = Path(__file__).resolve().parents[1]
JST = timezone(timedelta(hours=9))


def main() -> None:
    with tempfile.TemporaryDirectory(prefix="zensical-docs-", dir=ROOT) as temp:
        docs_dir = Path(temp)
        shutil.copytree(ROOT / "docs", docs_dir, dirs_exist_ok=True)

        for source in (ROOT / "docs").rglob("*.md"):
            relative = source.relative_to(ROOT)
            revision_date = subprocess.run(
                ["git", "log", "-1", "--format=%ct", "--", str(relative)],
                cwd=ROOT,
                check=True,
                capture_output=True,
                text=True,
            ).stdout.strip()
            if not revision_date:
                raise RuntimeError(f"Git の更新日を取得できません: {relative}")
            date = datetime.fromtimestamp(
                int(revision_date), JST
            ).strftime("%Y/%m/%d")
            destination = docs_dir / source.relative_to(ROOT / "docs")
            markdown = destination.read_text(encoding="utf-8")
            if not markdown.lstrip().startswith("> 最終更新日:"):
                destination.write_text(
                    f"> 最終更新日: {date}\n\n{markdown}", encoding="utf-8"
                )

        config_file = ROOT / ".zensical-build.yml"
        try:
            config_file.write_text(
                (ROOT / "mkdocs.yml").read_text(encoding="utf-8")
                + f"\ndocs_dir: {docs_dir.name}\n",
                encoding="utf-8",
            )
            subprocess.run(
                [sys.executable, "-m", "zensical", "build", "--strict", "--clean", "-f", str(config_file)],
                cwd=ROOT,
                check=True,
            )
            if not (ROOT / "site" / "index.html").is_file():
                raise RuntimeError("Zensical のトップページが生成されませんでした")
        finally:
            config_file.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
