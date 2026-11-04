# Reanalysis: rerun the bootstrap with the sampler from each R version
dat <- read.csv("data/data_final.csv")

cohens_d <- function(x) {
  m <- tapply(x$recall, x$condition, mean)
  s <- sqrt(mean(tapply(x$recall, x$condition, var)))
  unname((m["retrieval"] - m["control"]) / s)
}

boot_ci <- function(kind) {
  RNGkind(sample.kind = kind)  # "Rounding" = R < 3.6, "Rejection" = R >= 3.6
  set.seed(2018)
  boot <- replicate(2000, cohens_d(dat[sample(nrow(dat), replace = TRUE), ]))
  round(quantile(boot, c(.025, .975)), 2)
}

ci <- rbind("2019 (R 3.5.3)" = suppressWarnings(boot_ci("Rounding")),
            "2026 (R 4.6.1)" = boot_ci("Rejection"))
data.frame(d = round(cohens_d(dat), 2), lower = ci[, 1], upper = ci[, 2],
           includes_0 = ci[, 1] < 0)
