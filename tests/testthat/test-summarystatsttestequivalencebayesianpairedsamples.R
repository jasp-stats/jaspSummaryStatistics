context("Summary Statistics Bayesian Equivalence Paired Samples T-Test")

# Test 1: Default prior, two-sided, t + sample size input
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianPairedSamples")
options$tStatistic <- 1.5
options$sampleSize <- 25
options$priorandposterior <- TRUE
options$priorandposteriorAdditionalInfo <- TRUE
options$massPriorPosterior <- TRUE
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianPairedSamples", "debug.csv", options)

test_that("Bayesian Equivalence Paired Samples T-Test table results match", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(1.5, 25, "Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           1.5, 25, "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           1.5, 25, "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Main equivalence table")
})

test_that("Prior and Posterior plot matches", {
  plotName <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_priorPosteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "equivalence-prior-and-posterior-paired")
})

test_that("Prior and Posterior mass table results match", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_massTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("\U003B4 \U02208 I", ".", ".",
                           "\U003B4 \U02209 I", ".", "."),
                      label = "Mass table")
})

# Test 2: One-sided (greater), informative Cauchy prior
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianPairedSamples")
options$tStatistic <- 2.0
options$sampleSize <- 30
options$alternative <- "greater"
options$effectSizeStandardized <- "informative"
options$informativeStandardizedEffectSize <- "cauchy"
options$informativeCauchyLocation <- 0.3
options$informativeCauchyScale <- 0.5
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianPairedSamples", "debug.csv", options)

test_that("Bayesian Equivalence Paired Samples T-Test with informative Cauchy prior", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(2.0, 30, "Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           2.0, 30, "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           2.0, 30, "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Informative Cauchy prior table")
})

# Test 3: Cohen's d input type
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianPairedSamples")
options$inputType <- "cohensD"
options$cohensD <- 0.3
options$sampleSize <- 20
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianPairedSamples", "debug.csv", options)

test_that("Bayesian Equivalence Paired Samples T-Test with Cohen's d input", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(".", 20, "Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           ".", 20, "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           ".", 20, "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Cohen's d input table")
})

# Test 4: Mean difference and SD input type
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianPairedSamples")
options$inputType <- "meanDiffAndSD"
options$meanDifference <- 1.5
options$sdDifference <- 3.0
options$sampleSize <- 25
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianPairedSamples", "debug.csv", options)

test_that("Bayesian Equivalence Paired Samples T-Test with mean diff and SD input", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(".", 25, "Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           ".", 25, "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           ".", 25, "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Mean diff and SD input table")
})

# Test 5: BF01 type
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianPairedSamples")
options$tStatistic <- 1.5
options$sampleSize <- 25
options$bayesFactorType <- "BF01"
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianPairedSamples", "debug.csv", options)

test_that("Bayesian Equivalence Paired Samples T-Test with BF01", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(1.5, 25, "Overlapping (all vs. inside)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           1.5, 25, "Overlapping (all vs. outside)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           1.5, 25, "Non-overlapping (outside vs. inside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "BF01 table")
})

# Test 6: One-sided (less)
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianPairedSamples")
options$tStatistic <- -1.2
options$sampleSize <- 20
options$alternative <- "less"
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianPairedSamples", "debug.csv", options)

test_that("Bayesian Equivalence Paired Samples T-Test one-sided less", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(-1.2, 20, "Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           -1.2, 20, "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           -1.2, 20, "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "One-sided less table")
})

# Test 7: Informative t prior
test_that("Bayesian Equivalence Paired Samples T-Test with informative t prior", {
  options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianPairedSamples")
  options$tStatistic <- 2
  options$sampleSize <- 30
  options$effectSizeStandardized <- "informative"
  options$informativeStandardizedEffectSize <- "t"
  set.seed(1)
  results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianPairedSamples", "debug.csv", options)
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(2, 30, "Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           2, 30, "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           2, 30, "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Informative t prior table")
})
