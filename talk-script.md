# I Swear It Worked on My Computer — Talk Script

Oct 13, 2026

## How to use this script

This is a word-for-word script that follows `repro-talk.qmd` slide by slide. Bold lines in brackets, like **[Slide: Disclaimer]**, mark slide changes, and **[click]** marks a fragment or bullet reveal.

Read at a conversational pace (about 130 words a minute), it runs about 40–45 minutes plus the two videos. If you're short on time, the easiest cuts are the Python slides and the last three `rix()` code-walk slides.

It's meant to be said, not read: use it to rehearse, then speak from the slides.

## 1. Opening

**[Slide: Title]**

Thanks for having me. The title of this talk is a sentence I suspect everyone in this room has said, or at least thought: "I swear it worked on my computer!" Today is about why that happens, and what we can do so that it stops being our excuse.

**[Slide: Disclaimer]**

One quick disclaimer. Most of my examples will be in R, because that's what I use. But almost everything I say applies to Python and other languages too, and I'll show a couple of Python examples to prove it.

**[Slide: The Replication Crisis]**

Let's start with where we've been. About a decade ago, psychology ran into what we now call the replication crisis. This figure, adapted from Munafò and colleagues' manifesto for reproducible science, shows the cycle of research. Now let's look at all the places it can go wrong.

**[click]** A lack of replication: only about 1 in 1000 papers is a close replication.

**[click]** Low statistical power.

**[click]** P-hacking.

**[click]** HARKing: hypothesizing after the results are known.

**[click]** And publication bias, and not sharing data.

Each threat compounds the others, and the result was a literature where many findings didn't hold up.

**[Slide: Credibility Revolution]**

But I like to tell the more optimistic version of that story. We didn't just have a crisis, we had a *credibility revolution*. The field responded with preregistration, registered reports, larger samples, and open data and code. A lot has changed for the better.

**[Slide: Open Science]**

One product of that revolution is open science.

**[click]** Open science means being open and transparent at every stage of the research process, not just at the end when you publish.

**[click]** Casillas and colleagues break it into three parts.

**[click]** *Dissemination*: what we commit to and share, and when. That covers preregistration, registered reports and preprints. (The figure, adapted from Casillas and colleagues, maps these pieces out.)

**[click]** *Stance*: being upfront about ourselves and our materials. That covers positionality, conflicts of interest, and open data.

**[click]** And *workflow*: how the work actually gets done. That's where I'm spending today, and the question is easy to ask and surprisingly hard to answer: if I took your project folder today, could I rerun it and get your numbers?

## 2. What reproducibility means

**[Slide: What is Reproducibility?]**

First, some vocabulary, because these words get used loosely. This table crosses two questions: is it the same data or different data, and the same analysis or a different one?

**[click]** Same data, same analysis: that's *reproducible*. **[click]** Different data, same analysis: *replicable*, which is what the replication crisis was about. **[click]** Same data, different analysis: *robust*. **[click]** And different data, different analysis: *generalisable*.

Today I'm in the top-left cell: reproducibility. Same data, same code. That sounds like the easy one: you have the data, you have the code, you press run. So let me show you what happens when you actually try.

**[Slide: Demo]**

Here's a project on GitHub: the data, the code, everything you'd normally share.

**[Slide: Demo: it runs, but...]** **[Play video; pause as needed]**

The data here are simulated, but the setup will be familiar. First, here's the whole analysis script. At the top: the paper reports t(62) = 2.91, p = .005, d = 0.73. Then it reads the data, runs a t-test, and computes Cohen's d.

Now I'm a stranger who downloaded this repo. I open R and run the first line: read the data. It fails, because it reads from */Users/jasongeller/Dropbox*. That's my laptop. Nobody else has that folder.

So I do what all of us would do: look in the data folder. Two files: *data_final.csv* and *data_final_v2.csv*. "Final" sounds right, so I load that one.

Look at the first few rows. There's an *attn_check* column, and some people failed it. Keep that in mind.

Now the t-test. It runs. No error, no warning. t = 1.39, p = .17. And Cohen's d is 0.31, not 0.73. Not significant.

What happened? *data_final_v2* is the file with the attention-check failures removed. Nothing in the repo said so. Same code, same repo, different conclusion, and nobody would ever know.

**[Slide: Demo: it breaks]** **[Play video]**

Now say I fixed all of that: relative paths, one clearly named data file, a README. Here's a different project, on what I call the stranger's laptop: a clean machine with an empty home folder and an older version of Quarto.

It fails three times. First, the PDF format needs Quarto 1.4 or later, and this machine has 1.3. Second, the palmerpenguins package isn't installed. Third, CmdStan, which brms needs to fit the model, isn't there either.

None of these is a bug in my code. The code is fine, and the data is fine. What's different is the *environment* around it. So sharing data and code is not enough. This is the everyday version of "I swear it worked on my computer."

**[Slide: Computational Reproducibility]**

That's why I want to be more specific and talk about *computational* reproducibility. The UK Reproducibility Network primer defines it as the "ability to obtain consistent computational results using the same input data, computational steps, methods, code, and conditions of analysis."

Notice how much is packed into that definition: the data, the code, the steps, and the *conditions* the analysis ran under. "Conditions of analysis" is exactly what broke in the second demo. Hold on to that phrase, because it's what the second half of this talk is about.

In practice, reproducibility isn't yes-or-no. You can share some of those pieces and not others, and every piece you add gets you closer. So it helps to think of it as a spectrum.

**[Slide: Reproducibility Spectrum]**

Here's the spectrum, and it's the vocabulary for the rest of the talk. On the left is "not reproducible". You start with code. Then you add the data. Then documentation, so someone knows what to run and in what order. Then the article itself, linked to the code and data. And on the right is the gold standard, where you also capture the environment: the software the analysis actually ran on.

Each step gets you closer. Keep this ladder in mind, because each study I'm about to show you breaks at a different rung.

## 3. How psychology is doing

**[Slide: Psychology: about half reproduce]**

That failure isn't just me and my laptop. We now have data on this.

This is from the SCORE project, published this year in *Nature* by Miske and colleagues. They sampled 600 papers from 62 journals across the social and behavioural sciences, published between 2009 and 2018, and tried to reproduce them.

**[click]** Look at the psychology row, which I've boxed. In panel b, of the psychology papers the teams could actually attempt, a bit over half were precisely reproduced. Another fifth or so were approximately reproduced, and about a quarter weren't reproduced at all. That puts psychology roughly mid-pack across fields.

But look at panel a, on the left. That bar is tiny. The "about half" is only out of the papers that could be *attempted*. Which raises the obvious question: how many could be?

**[Slide: Few papers can be checked]**

The answer is: not many.

**[click]** This is availability by field. Everything in grey on the right is papers with neither data nor code available. For psychology, roughly three-quarters of the bar is grey. Only around a quarter had data available in any form, and only a small slice, around 15%, had both data *and* code.

So that 50% reproduction rate is a best case: it's half of the small minority that shared anything. The rest simply can't be checked.

Which leads to the next question. When people *do* share their materials, are they actually usable?

**[Slide: Shared ≠ usable]**

Dan Quintana looked at exactly this in a preprint from this September. He downloaded the shared materials from OSF repositories for 334 papers in *Psychological Science*, the *Journal of Memory and Language*, and the *Journal of Experimental Social Psychology*. The question: when materials are shared, can you reuse them?

**[click]** The top panel shows code red flags. A third of papers with code, 34%, had a hard-coded absolute path: something like `C:/Users/jason/Desktop/final_analysis`, which exists only on the author's computer. And 40% referenced a file that wasn't in the repository at all.

The bottom panel is documentation. Only 21% had a README file, and only 30% had any documentation at all.

So sharing is necessary, but shared is not the same as usable.

**[Slide: READMEs help, but only so far]**

So can documentation fix this? The Institute for Replication tested that. In a mass reproducibility project led by Brodeur, Abdul Baki and Fazio, 67 teams each tried to reproduce one of 67 *Psychological Science* papers from 2024 and 2025.

Overall, 58% were fully reproducible from the final analysis data, but only 28% from the raw data.

**[click]** Here they're split by README quality: no README on the left, a clear README in the middle, an unclear one on the right.

Look at the boxed rows in the middle panel. A clear README takes "reproducible from analysis data" from 50% up to 88%. That's a big effect. Documentation fixes the question "what do I run?"

But look at the row just above it. Starting from raw data, a clear README gets you to 31%, barely better than the 27% with no README at all.

**[click]** So a clear README gets 88% from analysis data, but only 31% from raw data. Documentation tells you what to run. It doesn't fix "it won't run on my machine."

**[Slide: Psychology: not so good]**

So where does that leave us? Back to the spectrum.

**[click]** Let's place these studies on it. In SCORE, most papers never get past the first rungs: nothing shared, nothing to check. In Quintana's data, materials are shared, but often hard to reuse. And in the Institute for Replication project, even a clear README only gets you so far once you start from raw data.

**[click]** Code, data, and a README get you partway. The **environment** is the missing step, and that's the rest of this talk.

## 4. The computational environment

**[Slide: The Computational Environment (section title)]**

So let's talk about the environment.

**[Slide: Which "reproducible"?]**

We just landed on the last box of the spectrum. But what does it actually mean to say "my environment is reproducible"? It turns out that phrase hides several different claims, and this grid pulls them apart.

The columns are two directions. *Across space* means on another machine or another operating system, today. *Across time* means years from now.

The rows are three levels, from weakest to strongest. First, *the environment builds*: you can install everything at all. Second, *the results are the same*: same versions, same numbers. And third, the strictest, *the bytes are the same*: bitwise reproducibility, where the files are literally identical down to their hashes.

I won't go through every cell. The punchline is that most tools cover only one or two of these six boxes. So the useful question isn't "is it reproducible?" It's "*which boxes* does it tick?" When we get to specific tools, I'll bring this grid back as a scorecard.

But first, let's look at how the environment breaks.

**[Slide: Environment Fragility]**

Set bitwise reproducibility aside for now. Even R code that runs without a single error sits on top of four layers, and each of them can drift across space and time.

**[click]** First, the version of R itself. **[click]** Second, your R packages. **[click]** Third, document tools: Pandoc, LaTeX, Quarto. **[click]** And fourth, the layer nobody thinks about: system libraries and compilers.

That last layer is things like gcc, the compiler that turns the C and C++ code inside many R packages into machine code on your computer. Or libpng, the operating system's library that R uses to save plots. Or BLAS and LAPACK, the linear algebra libraries underneath all of R's matrix math. None of these are R packages, so no R tool tracks them.

Let's take the layers one at a time.

**[Slide: 1. R version]**

**[click]** Syntax changes. The native pipe, `|>`, only exists since R 4.1. Run that code on R 4.0 and it won't even parse.

**[click]** Defaults change. In R 4.0, R stopped turning strings into factors by default.

**[click]** Here's the same two lines of code. On R 3.6, `group` is a factor, and converting it to numbers gives you 1 and 2. On R 4.0 and later, it's a character vector, and you get `NA`, `NA`. Same code, different object.

**[click]** And random numbers change. R 3.6 changed how `sample()` draws.

**[click]** So the same seed gives you different draws: 3, 8, 4 on R 3.5, and 3, 10, 2 on R 3.6 and later. If your analysis involves any resampling, bootstrapping or simulation, your numbers move, and nothing tells you.

**[Slide: 2. R packages]**

Packages change too. **[click]** Functions get renamed or deprecated: `dplyr::cur_data()` is now `dplyr::pick()`, and the old one warns you it's going away. **[click]** And some code reaches into packages' internal functions. That's discouraged, but people do it, and those can change or vanish without notice.

**[Slide: 3. Document tools]**

Third, document tools. **[click]** Quarto and R Markdown call Pandoc and LaTeX, and each of those has its own version, outside of R.

**[click]** This bit me while making the demo for this talk. The HTML rendered fine, but the PDF failed…

**[click]** …with this error: `lualatex-math.sty` not found. One LaTeX package was missing. Nothing to do with my R code.

**[Slide: 4. System libraries and compilers]**

And fourth, system libraries and compilers. **[click]** Many R packages contain compiled code, in C, C++ or Fortran, and they lean on libraries from the operating system.

**[click]** Today, CRAN hands you a ready-made binary. But years from now, for an old version, it may only have the source code. Then your machine compiles it, with *today's* compiler and *today's* libraries.

**[click]** And the same script can give different results with a different BLAS. Here's an example.

**[Slide: 4. System libraries and compilers (continued)]**

**[click]** This is based on an illustration by Danielle Navarro. It draws random numbers from a multivariate normal using `MASS::mvrnorm()`, with the same seed, on three operating systems.

**[click]** On macOS, you get one set of numbers. On Ubuntu and Windows, you get a completely different set. Not different in the 15th decimal place: different numbers.

Why? `mvrnorm()` uses an eigendecomposition, and an eigenvector is only defined up to its sign. Different BLAS and LAPACK libraries can return it with the sign flipped, and that flip carries straight through to your draws. Same R code, same seed, different results, purely because of the system library underneath. (For what it's worth, `mvtnorm::rmvnorm()` doesn't have this problem.)

**[Slide: Python, too: language version]**

And before the Python users relax: this isn't an R problem.

**[click]** Syntax: `match` statements only exist from Python 3.10, and the walrus operator from 3.8.

**[click]** Random numbers: in Python 3.10, you could sample from a set, but the draws depend on the set's order, which changes every time you run the script.

**[click]** So with the same seed, you get `a`, `b` on one run and `c`, `a` on the next. And in Python 3.11, the same line is simply an error.

**[Slide: Python, too: packages]**

**[click]** Packages change defaults loudly. In pandas 1.5, if you grouped and took the mean, pandas quietly dropped your text columns.

**[click]** In pandas 2.0, the same code throws a TypeError.

**[click]** They also change defaults silently, which is worse. numpy 2.0 changed how it promotes types.

**[click]** So 0.1 as a float32, plus 0.2, gives you one number in numpy 1.26 and a different one in numpy 2.0. No error, no warning, different answer.

**[click]** Functions get removed: `np.float` in numpy 1.24, `DataFrame.append()` in pandas 2.0. **[click]** Models change: scikit-learn 0.22 switched the default solver for logistic regression, so the same call gives different coefficients. **[click]** And numpy links against OpenBLAS, MKL or Apple Accelerate depending on how you installed it, which is the same BLAS story we just saw in R.

## 5. Managing the environment: renv and Docker

**[Slide: Managing the environment]**

So what do people do about this today?

**[click]** The usual answer is to combine several incomplete tools, each of which stabilises one part of the environment, and each needs its own expertise: `{renv}`, `{groundhog}`, `{rang}`, `{rig}`, Docker.

**[click]** And it gets more complicated as soon as you add another language, like Python or Julia. **[click]** On the Python side, uv seems to work well.

Let me look at the two most common options in R.

**[Slide: {renv}]**

**[click]** `{renv}` is the most popular reproducibility package in R, and it's very easy to use.

**[click]** You run `renv::init()`, and it snapshots the packages your project uses, with their versions, into a file called `renv.lock`.

**[click]** Someone else runs `renv::restore()`, and it reinstalls those versions.

**[click]** **But** it only records the version of R. It doesn't restore it. For that, you'd need another tool, like `{rig}`.

**[click]** **And** installing old package versions can fail, because the operating system dependencies they need to compile aren't there anymore. That's layer four again.

**[Slide: {renv}: which boxes?]**

So here's the first scorecard, using the grid from before. The claim is "use renv for reproducibility."

Every box that renv touches is *partly*. Does the environment build on another machine? Partly: you get the same package versions, but not the same R or system libraries. Years later? Partly: old packages often fail to install. Same results? Partly: same packages, but R and BLAS can differ. And bitwise reproducibility isn't addressed at all.

That's not a knock on renv. It does exactly what it says. It just only covers one layer of four.

**[Slide: Docker: what a container does]**

The other common answer is Docker.

The idea is: you write a *Dockerfile*, which is a recipe. Building it gives you an *image*, which is the whole environment, frozen. And running an image gives you a *container*.

This figure, adapted from Bruno Rodrigues, shows why that's appealing. On the left, without a container, the same `analysis.R` runs on macOS with R 4.6.1 and on Windows with R 4.5.3. Different setups, potentially different outputs.

On the right, both machines run Docker, and inside the container is the same operating system, Ubuntu, the same R and the same packages. The container brings its own environment, so you get the same output.

**[Slide: Docker: rebuilding ≠ reproducing]**

But there's a catch. Look at a typical Dockerfile. `FROM rocker/r-ver:latest`: which R? Whatever "latest" means on the day you build it. `apt-get install`: today's Ubuntu libraries. `install.packages("brms")`: today's CRAN.

**[click]** So the recipe drifts. Every line fetches whatever is current *on build day*. Only the saved image is frozen, not the recipe.

**[click]** That means you have to archive the image itself, which is often several gigabytes, and tags on Docker Hub can move or disappear.

**[click]** Even the same image can differ across machines. Containers run on the host's processor, and OpenBLAS picks different code for different CPUs, so the last digits can still change.

**[click]** And there are practical costs. You need some Linux know-how. Intel-only images run emulated, and slowly, on Apple Silicon Macs. Many university clusters don't allow Docker at all. And you're depending on one company as a single point of failure.

**[Slide: Docker: which boxes?]**

So here's Docker's scorecard, against the common claim that "Docker guarantees full computational reproducibility."

Across space, it's strong. Pull the saved image anywhere and it builds, with the same versions. Bitwise is partly, because of that CPU-dependent BLAS.

But across time, it's weak. Rebuilding the Dockerfile drifts. You only get the same results years later if you archived the image. And bitwise over time isn't addressed.

So renv gives us partly everywhere, and Docker gives us space but not time. Is there something that covers more of the grid?

## 6. Nix and {rix}

**[Slide: Nix/{Rix}]**

This is where Nix comes in.

**[click]** Nix is a package manager. It's also a language and a build tool, but think of it as a package manager.

**[click]** It installs and manages R and Python packages, *and* the software and system dependencies underneath them. All four layers.

**[click]** It was built for reproducible builds. R, R packages and system dependencies are all declared in one text file, called a *Nix expression*.

**[click]** And every input is pinned by a hash. So the same expression gives you the same environment, on any machine. Everything lives in its own folder, so nothing clashes with what's already on your computer.

**[click]** In terms of our spectrum, this is the "+ Environment" step: the gold standard.

**[Slide: Nix is like an app store]**

If that sounds abstract, here's how I think about it.

**[click]** Nix is like the app store on your phone, but for research software.

**[click]** There's one catalog, called `nixpkgs`. It has R, R packages, Quarto, CmdStan, system libraries, all in one place.

**[click]** Your `default.nix` file is your list of "apps" to install.

**[click]** But here's the twist. Your phone auto-updates, and so does CRAN. Install brms today and again next year, and you get different versions. In Nix, the store is **frozen on a date**.

**[click]** You pick a snapshot date, like August 24th, 2026, and auto-update is off. Anyone who installs from that snapshot, on any machine, next month or in five years, gets exactly the same apps.

**[Slide: How big is nixpkgs?]**

You might wonder whether this store actually has what you need.

**[click]** This plot is from Repology, which tracks every package repository. The x-axis is how many packages a repository has, and the y-axis is how many are up to date. `nixpkgs`, boxed in the top right, is the biggest and freshest repository there is. It beats CRAN itself, which is the small box.

**[click]** It has nearly all of CRAN and Bioconductor, prebuilt. The binaries come from a cache, so installs are fast enough for daily work. And Nix works without admin rights, so you can use it on an HPC cluster.

**[Slide: Nix: a Nix expression (default.nix), lines 2–3]**

So what does one of these files look like? Here's a `default.nix` for the demo project from earlier. I'll walk through it in pieces.

Lines 2 and 3 are the snapshot. Every package definition comes from `nixpkgs` exactly as it was on August 24th, 2026.

**[Next slide: lines 4–6]**

These are the R packages from that snapshot: brms, knitr, palmerpenguins and rmarkdown. Exact versions, plus all of their dependencies.

**[Next slide: lines 7–14]**

This block is cmdstanr, which isn't on CRAN, so it comes from GitHub. It's pinned to an exact commit *and* a content hash. If anything on GitHub changes, the build fails rather than silently giving you something different. If you write this by hand, you have to compute that hash yourself.

**[Next slide: lines 15–17]**

This is the system software: R itself, Quarto, pandoc and CmdStan, all from the same snapshot. Notice that's the layer renv couldn't touch.

**[Next slide: lines 18–21]**

And finally, the shell: everything above, bundled into the environment that `nix-shell` opens.

**[Slide: Nix: the empirical evidence]**

And this isn't just a promise. Malka, Zacchiroli and Zimmermann tested it at scale. They rebuilt **709,816 packages** from `nixpkgs` snapshots taken every four months between 2017 and 2023.

**[click]** Rebuildable: 99.7 to 99.9% still build from their description, years later.

**[click]** Bitwise reproducible: 69% in 2017, rising to 91% in 2023.

**[click]** Functional reproducibility, meaning the same results, wasn't measured directly. But it follows for every package that rebuilds. Because every input is pinned by a hash, a rebuild can fail, but it can't quietly succeed with different versions. That's not true of Docker.

**[Slide: Nix: which boxes?]**

So here's the Nix scorecard. Across space: the same `default.nix` builds on any machine, with the same pinned versions everywhere. Across time: 99.7 to 99.9% still rebuild, with the same pinned inputs years later. The only "partly" is the strictest level, bitwise: mostly there, 91% in 2023, and rising.

Compare that to renv's row of partlys and Docker's gap across time.

Now, writing a `default.nix` by hand means learning the Nix language, and I don't expect anyone in this room to want to do that. That's where `{rix}` comes in. It writes that file for you, from R.

**[Slide: Nix/Rix]**

**[click]** `{rix}` makes writing Nix expressions easy. It's one R function, `rix()`.

**[click]** You install it like any other R package, from the rOpenSci r-universe.

**[Slide: the rix() call, `date`]**

Here's the `rix()` call that generated the file I just showed you.

The `date` argument becomes the snapshot line in `default.nix`. It pins *everything* to one snapshot of nixpkgs, so R and every package come in the versions they had on that day, on any machine.

**[Next slide: `r_pkgs`]**

`r_pkgs` are your CRAN packages, at their versions on that date. knitr and rmarkdown are here because Quarto needs them to run R code.

**[Next slide: `git_pkgs`]**

`git_pkgs` are packages that aren't on CRAN. cmdstanr is pinned to an exact commit, the v0.9.0 release, not "whatever is on GitHub today". And `{rix}` computes the hash for you.

**[Next slide: `system_pkgs`]**

`system_pkgs` is software outside R. Quarto and CmdStan: two of the three things that broke in the demo. Now they're part of the environment.

**[Next slide: `shell_hook`]**

`shell_hook` runs commands every time you enter the environment. Here, it tells cmdstanr where CmdStan lives.

**[Next slide: `ide`, `project_path`, `overwrite`]**

And the last three arguments: no IDE here, though RStudio, Positron and VS Code also work, and write `default.nix` into this folder.

One rule: never hand-edit the generated `default.nix`. All of your configuration goes through `rix()`.

**[Slide: Nix/Rix: Python too]**

And for the Python users: `py_conf` adds Python to the same environment. Here I ask for Python 3.12 with pandas and numpy.

When I run Python inside the environment, I get Python 3.12, with pandas and numpy from the same August 24th snapshot. One `default.nix` pins R, Python *and* both sets of packages. And R reaches that exact Python through `reticulate`, never whatever Python happens to be on the system.

**[Slide: Nix/Rix: using it]**

So how do you use it? Three commands.

**[click]** First, run the R script that calls `rix()`, which writes `default.nix`.

**[click]** Second, `nix-build` builds the environment. It's slow the first time, then cached.

**[click]** Third, `nix-shell --pure` runs your render inside that environment.

**[click]** Before any of this, you install Nix once.

**[click]** The `--pure` flag matters. It means nothing from your own machine leaks in: not your R, not your packages, not the CmdStan sitting in your home folder.

**[click]** And plain `nix-shell`, without `--run`, just drops you into the environment so you can work interactively.

**[Slide: Illustration (section title with code)]**

To put it all together: here's the `rix()` call, and here are the four steps. Write `default.nix`, build the environment once, enter it, and render inside it.

**[Slide: Nix/Rix: using it (recording)]**

Let me show you that running for real. **[Play video]**

This is a copy of the same demo repository that failed earlier. First, `gen-env.R` writes `default.nix`. Then `nix-build` prints a path in the Nix store: that's the environment, and it's already cached here. Then `nix-shell --pure` renders both the HTML and the PDF, with no R, packages or CmdStan from my own machine. I've compressed the idle time; compiling the brms model takes about two minutes live.

You'll see a couple of warnings scroll past. The "evaluation warning" lines are a harmless deprecation notice from Nix, and the GitHub message is rix looking up the cmdstanr commit date without a login token. Neither affects the result.

**[Slide: {Rix} not perfect]**

Now, I don't want to oversell this. {rix} isn't perfect, and here are the snags I've actually hit.

**[click]** Misdeclared dependencies: one R package listed a dependency under Imports when it belonged in Suggests, which broke the build.

**[click]** A parsing bug, with a dependency written as `R(>= x)` with no space, for a package whose name ends in R. That's already fixed in the development version.

**[click]** On macOS, the description stays valid, but an operating system update can break today's build. **[click]** My recommendation there is to build inside Docker.

**[click]** Isolation: always use `nix-shell --pure`, so the shell only sees the declared environment and nothing installed on your computer.

**[click]** And getting {rix} working on Windows can be cumbersome.

## 7. Continuous integration

**[Slide: Continuous Integration (CI)]**

There's one more piece. Nix *describes* an environment that should still build years from now. But how do you know it still does? You check, automatically.

**[click]** Every week, a fresh machine rebuilds from your `default.nix`. That tells you **the same description still builds**.

**[click]** Then you add a check that your key estimates match saved values. That tells you you get **the same result, years later**.

**[click]** In terms of the grid, that's the *across time* column: you're not just hoping it holds up over time, you're testing it every week.

**[Slide: CI: what it is]**

This is called continuous integration, or CI.

**[click]** Every time you push your code, a CI service starts a fresh computer and reruns your pipeline from scratch. I'll use GitHub Actions as the example, but GitLab and others work the same way, and with Nix the workflow barely changes between them.

**[click]** You get a green check if it ran, or a red X if it broke, plus an email telling you which step failed.

**[click]** It's free for public repositories, with a monthly allowance for private ones.

**[click]** So "it works on my laptop" becomes **"it works on a clean machine, every push."**

**[Slide: CI: why Nix + CI]**

Why combine it with Nix?

**[click]** Without Nix, your CI workflow needs its own setup steps: install R, install packages, install CmdStan, install Quarto. That's a *second* definition of your environment, and it can drift away from the one on your laptop.

**[click]** With Nix, CI builds the *same* `default.nix` you use locally. One definition, used everywhere.

**[click]** And a pinned environment plus a weekly run gives you an early warning if anything upstream disappears, like a GitHub commit or a download link.

**[Slide: CI: the payoff]**

**[click]** The payoff is a green badge in your README that says: this analysis reran from scratch on a clean machine.

**[click]** It's one line of Markdown.

**[click]** That's a claim reviewers, and future you, can check with one click.

**[click]** And when it goes red, it tells you *before* a reviewer does.

## 8. Closing

**[Slide: Beyond the environment]**

The environment is today's focus, but it isn't the whole story. Three more things matter.

**[click]** Workflow. Tools like Quarto put your code, prose and output in one document, so there's a single source of truth from raw data all the way to the manuscript. No copying numbers from R into Word.

**[click]** Pipelines. Remember the README result: from raw data, even a clear README only got to 31%. `{targets}` turns that README into a pipeline you can run. You declare the steps from raw data to manuscript once, and `tar_make()` runs them, in order, every time, skipping anything that hasn't changed.

**[click]** And if you've bought into `{rix}`, there's `{rixpress}`, from the same author. It's the same idea built on Nix, so every step of the pipeline runs inside the frozen environment.

**[click]** And where you host your materials. OSF Projects are being phased out, which is a good reminder not to bet your archive on one platform. **[click]** GitHub for the living project, and Zenodo for an archived, citable copy, is a solid combination.

**[Slide: What a Lab Can Actually Do]**

I've spent a lot of time on Nix, and I know it's a big step. If your lab isn't ready for Nix and {rix}, that's fine. Start smaller.

**[click]** Use `{renv}` and `{rig}` to snapshot your R packages and manage your R version. **[click]** `{groundhog}` is another option. **[click]** Docker, if you want one shared environment for the lab. **[click]** And `{targets}`, the pipeline tool we just saw, which works with or without Nix.

Remember the spectrum: reproducibility is a *ladder*, not a cliff. Every rung you climb helps.

**[Slide: Culture, Not Just Tools]**

And tools only get you so far. A lot of this is culture.

**[click]** Train your RAs in these tools from day one. **[click]** Make "can a stranger rerun this?" a normal question in your lab. **[click]** Include these tools, and this conversation, in your courses.

**[click]** Because, in the end, incentives matter more than any single tool.

**[Slide: Takeaways]**

So, three things to take away.

**[click]** First: **shared is not the same as reproducible.** **[click]** About half of psychology papers reproduce, and only a few can even be checked. **[click]** So share your data *and* your code, then check that someone else can actually run them.

**[click]** Second: **document it.** **[click]** A clear README: what to run, in what order, starting from the raw data.

**[click]** And third: **freeze the environment.** **[click]** `{rix}` declares R, your packages and your system tools in one file, pinned to a date. **[click]** And CI reruns it from scratch, so you find out before a reviewer does.

If you do those three things, you'll never have to say "I swear it worked on my computer" again. You'll be able to show that it works on everyone's.

**[Slide: Thanks!]**

Thank you.

**[click]** If you want to learn more about Nix and {rix}, check out the tutorial paper I wrote with Felipe Vieira and Bruno Rodrigues.

**[click]** "Why risk it, when you can {rix} it", forthcoming in *AMPPS*, and the preprint is on PsyArXiv now.

I'm happy to take questions.
