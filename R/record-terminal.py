# Record real terminal sessions as an asciicast v2 file, typing each command visibly.
# Used for media/nix-build-demo.cast (run inside a copy of the Rix-Nix_Test repo):
#   python3 R/record-terminal.py out.cast "Rscript gen-env.R" "nix-build" \
#     "nix-shell --pure --run \"quarto render nix_rix_example.qmd\""
# Then: agg --idle-time-limit 2 --font-size 22 --theme github-light out.cast out.gif
#       ffmpeg -i out.gif -pix_fmt yuv420p -c:v libx264 -crf 20 media/nix-build-demo.mp4
import json, os, pty, select, struct, fcntl, termios, time, sys, random

COLS, ROWS = 100, 26
cmds = sys.argv[2:]
out = open(sys.argv[1], "w")
out.write(json.dumps({"version": 2, "width": COLS, "height": ROWS,
                      "env": {"TERM": "xterm-256color", "SHELL": "/bin/bash"}}) + "\n")
t0 = time.time()
def emit(s):
    out.write(json.dumps([round(time.time() - t0, 4), "o", s]) + "\n"); out.flush()

PROMPT = "\x1b[1;32m~/Rix-Nix_Test\x1b[0m $ "
random.seed(1)
for c in cmds:
    emit(PROMPT); time.sleep(0.6)
    for ch in c:
        emit(ch); time.sleep(0.045 + random.random() * 0.04)
    time.sleep(0.4); emit("\r\n")
    pid, fd = pty.fork()
    if pid == 0:
        os.execvpe("/bin/bash", ["/bin/bash", "--noprofile", "--norc", "-c", c], dict(os.environ, TERM="xterm-256color", COLUMNS=str(COLS), LINES=str(ROWS)))
    fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", ROWS, COLS, 0, 0))
    while True:
        r, _, _ = select.select([fd], [], [], 0.5)
        if r:
            try: data = os.read(fd, 4096)
            except OSError: break
            if not data: break
            emit(data.decode("utf-8", "replace"))
    os.waitpid(pid, 0)
    time.sleep(0.8)
emit(PROMPT); time.sleep(2)
out.close()
