# Live demo script: "it works on my computer"

Demo repo: `~/Rix-Nix_Test` (github.com/jgeller112/Rix-Nix_Test)

- `nix_rix_example.qmd`: penguins + brms, `backend = "cmdstanr"`
- `gen-env.R`: the `rix()` call that writes `default.nix`

## Setup (before the talk)

```bash
cd ~/Rix-Nix_Test
nix-build                        # warm the Nix store so the fixed render is fast on stage
export HOME_STRANGER=$(mktemp -d)
```

Your machine has CmdStan in `~/.cmdstan`. Running with an empty home folder
(`HOME=$HOME_STRANGER`) plays a stranger's laptop: your R packages still load,
but CmdStan disappears.

## Part 0: it runs, but gives a different answer (path demo)

Folder: `~/Rix-Nix_Test/path-demo` (simulated data, see `make-data.R`)

- `analysis.R` reads `/Users/jasongeller/Dropbox/study1/data_final_v2.csv` (hard-coded path)
- `data/data_final.csv`: everyone, including attention-check failures
- `data/data_final_v2.csv`: failures removed (the file the "paper" used)

Live, or play `media/path-demo.mp4`:

```bash
cd ~/Rix-Nix_Test/path-demo
cat analysis.R              # paper reports t(62) = 2.91, p = .005, d = 0.73
R --quiet --no-save
```

```r
dat <- read.csv("/Users/jasongeller/Dropbox/study1/data_final_v2.csv")  # error: my Dropbox
list.files("data")                     # data_final.csv, data_final_v2.csv
dat <- read.csv("data/data_final.csv") # the wrong one
head(dat)                              # note the attn_check column
t.test(recall ~ condition, data = dat, var.equal = TRUE)   # p = .17
```

Re-record: `python3 R/record-r-session.py out.cast media/path-demo-steps.txt`
(run from a copy of `path-demo`, without `make-data.R`), then `agg` + `ffmpeg` as in
`R/record-r-session.py`.

## Part 1: it breaks (start of Layer 1)

> "Here's a repo. One Quarto file. Let's render it."

```bash
HOME=$HOME_STRANGER quarto render nix_rix_example.qmd
```

**Failure 0: document tools (only if the stranger has an old Quarto)**

The qmd renders HTML *and* a PDF via Typst. Typst output needs Quarto 1.4+. On
Quarto 1.3 the render dies before any R code runs, with an error that never says
"your Quarto is too old":

```
ERROR: Validation of YAML front matter failed.
(line 6, columns 10--16) Field "format" has value default, which must instead be no possible value
```

`quarto --version` → `1.3.450` explains it. Your machine has 1.10, so this one only
appears in the backup recording (`media/rix-demo.mp4`).

**Failure 1: missing package**

```
there is no package called 'palmerpenguins'
```

(True on your machine as-is. Install it, or explain that you'd install it, and move on.)

**Failure 2: toolchain outside R**

```
cmdstanr::cmdstan_version()
  cmdstanr:::stop_no_path()
Quitting from nix_rix_example.qmd:21-29
```

> "brms and cmdstanr are installed. But the model needs CmdStan, a C++ toolchain
> no R package manager tracks. And even with it, would you get the same versions I had?"

## Part 2: it works (after the Nix / rix slides)

```bash
cat gen-env.R                    # the whole environment, one R function call
HOME=$HOME_STRANGER nix-shell --pure --run "quarto render nix_rix_example.qmd"
```

About 80 seconds, most of it compiling the Stan model.

Things to point out:

- `--pure`: nothing from your own machine leaks in: not your R, not your packages, not `~/.cmdstan`.
- R, brms, palmerpenguins, cmdstanr, CmdStan **and Quarto** are all pinned to one date (2026-08-24).
- cmdstanr isn't on CRAN, so it's pinned to a GitHub commit (v0.9.0).

## Real-world anecdote from building this

The newest snapshot (2026-09-23) failed to build: nixpkgs started requiring
`pname` for packages built from source, and rix still writes `name`. Pinning the
date to 2026-08-24 fixed it. Good material for the "Layer 1: real example" slide.
Even the reproducibility tools drift, and a pinned date is what protects you.

## Backup plan

Record a video or take screenshots of both parts before the talk, in case of slow Wi-Fi.
