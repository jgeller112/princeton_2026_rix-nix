# Box the Psychology row on Miske et al. (2026) Fig. 3 (reproducibility by field),
# matching the red box already on images/41586_2026_10203_Fig2_psych.png
# Input:  images/psych_repro.webp
# Output: images/psych_repro_box.png
#
# Run from the project root:  Rscript R/highlight-psych-repro.R

library(magick)

img <- image_read("images/psych_repro.webp")
info <- image_info(img)

highlight <- "#dc1428"

out <- image_draw(img)
# pixel coordinates of the Psychology row (origin top-left)
rect(xleft = 6, ytop = 312, xright = info$width - 6, ybottom = 404,
     border = highlight, lwd = 12)
dev.off()

image_write(out, "images/psych_repro_box.png", format = "png")
