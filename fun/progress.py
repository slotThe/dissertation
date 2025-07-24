# Compare with https://phdcomics.com/comics/archive.php?comicid=1915
#
# Uses the commit history of the main branch to create a pretty picture.

import matplotlib.pyplot as plt
import matplotlib.dates as md
from datetime import datetime
import subprocess
import re
from datetime import datetime


def run(cmd: str | list[str]) -> list[str]:
    return (
        subprocess.run(
            cmd.split() if isinstance(cmd, str) else cmd,
            capture_output=True,
            text=True,
        )
        .stdout.strip()
        .split("\n")
    )


### Gathering data

timestamps, sizes = [], []
for commit, date in [
    c.split()[:-2]
    for c in run(["git", "log", "--oneline", "--reverse", "--pretty=format:%H %ci"])
]:
    tree = run(f"git ls-tree -r {commit}")
    timestamps.append(datetime.strptime(date, "%Y-%m-%d"))
    hashes_fns = [t.split()[2:] for t in tree if re.match(r".+\.(tex|tikz)$", t)]
    sizes.append(sum(len(run(f"git show {commit}:{fn}")) for h, fn in hashes_fns))

### Plotting

plt.plot(timestamps, sizes)
plt.gca().xaxis.set_major_formatter(md.DateFormatter("%Y-%m-%d"))
plt.xticks(rotation=45)
plt.xlabel("Date")
plt.ylabel("Lines of TeX")

mark_date = datetime(2025, 4, 1)
plt.axvline(x=mark_date, color="red", linestyle="--", alpha=0.7)
plt.text(
    mark_date,
    max(sizes) * 0.8,
    "Deadline",
    rotation=270,
    ha="left",
    va="center",
    color="red",
)

plt.tight_layout()
plt.show()
