# Record a real interactive terminal session (shell, then an R console) as an
# asciicast v2 file, typing each line visibly and waiting for output to settle.
# Used for media/path-demo.cast (run inside a copy of Rix-Nix_Test/path-demo):
#   python3 R/record-r-session.py out.cast steps.txt
# steps.txt: one line per keystroke line. "#pause N" lines add an N-second pause.
# Then: agg --idle-time-limit 3 --font-size 22 --theme github-light out.cast out.gif
#       ffmpeg -i out.gif -pix_fmt yuv420p -c:v libx264 -crf 20 media/path-demo.mp4
import json, os, pty, select, struct, fcntl, termios, time, sys, random

COLS, ROWS = 96, 30
out = open(sys.argv[1], "w")
steps = open(sys.argv[2]).read().splitlines()
out.write(json.dumps({"version": 2, "width": COLS, "height": ROWS,
                      "env": {"TERM": "xterm-256color", "SHELL": "/bin/bash"}}) + "\n")
t0 = time.time()
def emit(s):
    out.write(json.dumps([round(time.time() - t0, 4), "o", s]) + "\n"); out.flush()

env = dict(os.environ, TERM="xterm-256color", COLUMNS=str(COLS), LINES=str(ROWS),
           PS1="\\[\\e[1;32m\\]~/Rix-Nix_Test/path-demo\\[\\e[0m\\] $ ", BASH_SILENCE_DEPRECATION_WARNING="1")
pid, fd = pty.fork()
if pid == 0:
    os.execvpe("/bin/bash", ["/bin/bash", "--noprofile", "--norc", "-i"], env)
fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", ROWS, COLS, 0, 0))

def drain(idle=1.0, limit=30):
    """Copy output to the cast until nothing new arrives for `idle` seconds."""
    last = time.time(); start = last
    while time.time() - last < idle and time.time() - start < limit:
        r, _, _ = select.select([fd], [], [], 0.1)
        if r:
            try: data = os.read(fd, 4096)
            except OSError: return
            if data: emit(data.decode("utf-8", "replace")); last = time.time()

random.seed(1)
drain(1.0)
for line in steps:
    if line.startswith("#pause"):
        time.sleep(float(line.split()[1])); continue
    time.sleep(0.5)
    for ch in line:
        os.write(fd, ch.encode()); time.sleep(0.04 + random.random() * 0.04)
        drain(0.0, 0.05)
    time.sleep(0.4)
    os.write(fd, b"\r")
    drain(1.2)
drain(1.0)
time.sleep(2); emit("")
out.close()
