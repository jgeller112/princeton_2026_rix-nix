# Put a cartoon crown on Simine Vazire for the "Credibility Revolution!" slide
# Input:  images/simine_outside3-scaled.jpg
# Output: images/sv-crown.png
#
# Run from the project root:  Rscript R/crown-simine.R

library(magick)

photo <- image_read("images/simine_outside3-scaled.jpg") |>
  image_crop("1800x1800+290+150") |>   # head and shoulders, square
  image_resize("900x900")

# transparent headroom so the crown can poke above the photo
headroom <- 200
canvas <- image_blank(900, 900 + headroom, color = "none") |>
  image_composite(photo, operator = "over", offset = paste0("+0+", headroom))

# crown in canvas pixel coordinates (y down), then tilted
cx <- 450; cy <- 250; tilt <- -8 * pi / 180; drop <- 45  # drop: nudge down onto the hair
turn <- function(x, y) {
  list(x = cx + (x - cx) * cos(tilt) - (y - cy) * sin(tilt),
       y = cy + drop + (x - cx) * sin(tilt) + (y - cy) * cos(tilt))
}

outline <- turn(c(230, 230, 340, 450, 560, 670, 670),
                c(380, 150, 250, 110, 250, 150, 380))
band    <- turn(c(230, 670, 670, 230), c(305, 305, 380, 380))
tips    <- turn(c(230, 450, 670), c(150, 110, 150))
gems    <- turn(c(335, 450, 565), c(342, 342, 342))

gold <- "#F5C542"; ink <- "#6B4E00"

out <- image_draw(canvas)
polygon(outline$x, outline$y, col = gold, border = ink, lwd = 10)
polygon(band$x, band$y, col = "#E9B525", border = ink, lwd = 10)
symbols(tips$x, tips$y, circles = rep(20, 3), inches = FALSE,
        add = TRUE, bg = gold, fg = ink, lwd = 8)
symbols(gems$x, gems$y, circles = c(20, 22, 20), inches = FALSE,
        add = TRUE, bg = c("#1F5FBF", "#D62828", "#1F5FBF"), fg = ink, lwd = 6)
dev.off()

image_write(out, "images/sv-crown.png", format = "png")
