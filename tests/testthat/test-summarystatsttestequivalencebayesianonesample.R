context("Summary Statistics Bayesian Equivalence One Sample T-Test")

# Test 1: Default prior, two-sided, t + sample size input
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianOneSample")
options$tStatistic <- 1.8
options$sampleSize <- 30
options$priorandposterior <- TRUE
options$priorandposteriorAdditionalInfo <- TRUE
options$massPriorPosterior <- TRUE
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianOneSample", "debug.csv", options)

test_that("Bayesian Equivalence One Sample T-Test table results match", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Main equivalence table")
})

test_that("Prior and Posterior plot matches", {
  plotName <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_priorPosteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "equivalence-prior-and-posterior-one")
})

test_that("Prior and Posterior mass table results match", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_massTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("\U003B4 \U02208 I", ".", ".",
                           "\U003B4 \U02209 I", ".", "."),
                      label = "Mass table")
})

# Test 2: One-sided (greater), informative Cauchy prior
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianOneSample")
options$tStatistic <- 2.0
options$sampleSize <- 40
options$alternative <- "greater"
options$effectSizeStandardized <- "informative"
options$informativeStandardizedEffectSize <- "cauchy"
options$informativeCauchyLocation <- 0.3
options$informativeCauchyScale <- 0.5
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianOneSample", "debug.csv", options)

test_that("Bayesian Equivalence One Sample T-Test with informative Cauchy prior", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Informative Cauchy prior table")
})

# Test 3: Cohen's d input type
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianOneSample")
options$inputType <- "cohensD"
options$cohensD <- 0.4
options$sampleSize <- 25
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianOneSample", "debug.csv", options)

test_that("Bayesian Equivalence One Sample T-Test with Cohen's d input", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Cohen's d input table")
})

# Test 4: Mean and SD input type
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianOneSample")
options$inputType <- "meanAndSD"
options$mean <- 5.2
options$sd <- 2.5
options$testValue <- 4.5
options$sampleSize <- 30
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianOneSample", "debug.csv", options)

test_that("Bayesian Equivalence One Sample T-Test with mean and SD input", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Mean and SD input table")
})

# Test 5: One-sided (less)
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianOneSample")
options$tStatistic <- -1.5
options$sampleSize <- 25
options$alternative <- "less"
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianOneSample", "debug.csv", options)

test_that("Bayesian Equivalence One Sample T-Test one-sided less", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "One-sided less table")
})

# Test 6: Informative normal prior
test_that("Bayesian Equivalence One Sample T-Test with informative normal prior", {
  options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianOneSample")
  options$tStatistic <- 2
  options$sampleSize <- 30
  options$effectSizeStandardized <- "informative"
  options$informativeStandardizedEffectSize <- "normal"
  set.seed(1)
  results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianOneSample", "debug.csv", options)
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Informative normal prior table")
})
