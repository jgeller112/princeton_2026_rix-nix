# Study 1: retrieval practice and recall
dat <- read.csv("data/data_final.csv")

cohens_d <- function(x) {
  m <- tapply(x$recall, x$condition, mean)
  s <- sqrt(mean(tapply(x$recall, x$condition, var)))
  unname((m["retrieval"] - m["control"]) / s)
}

set.seed(2018)
boot <- replicate(2000, cohens_d(dat[sample(nrow(dat), replace = TRUE), ]))

round(cohens_d(dat), 2)
round(quantile(boot, c(.025, .975)), 2)
