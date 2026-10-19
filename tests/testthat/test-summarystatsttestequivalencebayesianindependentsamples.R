context("Summary Statistics Bayesian Equivalence Independent Samples T-Test")

# Test 1: Default prior, two-sided, t + sample sizes input
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianIndependentSamples")
options$tStatistic <- 2.3
options$sampleSizeGroupOne <- 20
options$sampleSizeGroupTwo <- 20
options$priorandposterior <- TRUE
options$priorandposteriorAdditionalInfo <- TRUE
options$massPriorPosterior <- TRUE
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianIndependentSamples", "debug.csv", options)

test_that("Bayesian Equivalence Independent Samples T-Test table results match", {
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
  jaspTools::expect_equal_plots(testPlot, "equivalence-prior-and-posterior-ind")
})

test_that("Prior and Posterior mass table results match", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_massTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("\U003B4 \U02208 I", ".", ".",
                           "\U003B4 \U02209 I", ".", "."),
                      label = "Mass table")
})

# Test 2: One-sided (greater), informative Cauchy prior
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianIndependentSamples")
options$tStatistic <- 1.5
options$sampleSizeGroupOne <- 30
options$sampleSizeGroupTwo <- 30
options$alternative <- "greater"
options$effectSizeStandardized <- "informative"
options$informativeStandardizedEffectSize <- "cauchy"
options$informativeCauchyLocation <- 0.5
options$informativeCauchyScale <- 0.5
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianIndependentSamples", "debug.csv", options)

test_that("Bayesian Equivalence Independent Samples T-Test with informative Cauchy prior", {
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
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianIndependentSamples")
options$inputType <- "cohensD"
options$cohensD <- 0.5
options$sampleSizeGroupOne <- 25
options$sampleSizeGroupTwo <- 25
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianIndependentSamples", "debug.csv", options)

test_that("Bayesian Equivalence Independent Samples T-Test with Cohen's d input", {
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

# Test 4: Means and SDs input type
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianIndependentSamples")
options$inputType <- "meansAndSDs"
options$mean1 <- 10.5
options$mean2 <- 9.0
options$sd1 <- 3.0
options$sd2 <- 3.0
options$sampleSizeGroupOne <- 20
options$sampleSizeGroupTwo <- 20
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianIndependentSamples", "debug.csv", options)

test_that("Bayesian Equivalence Independent Samples T-Test with means and SDs input", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Means and SDs input table")
})

# Test 5: BF01 type
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianIndependentSamples")
options$tStatistic <- 2.3
options$sampleSizeGroupOne <- 20
options$sampleSizeGroupTwo <- 20
options$bayesFactorType <- "BF01"
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianIndependentSamples", "debug.csv", options)

test_that("Bayesian Equivalence Independent Samples T-Test with BF01", {
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (all vs. inside)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (all vs. outside)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (outside vs. inside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "BF01 table")
})

# Test 6: Informative normal prior
options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianIndependentSamples")
options$tStatistic <- 2
options$sampleSizeGroupOne <- 20
options$sampleSizeGroupTwo <- 20
options$effectSizeStandardized <- "informative"
options$informativeStandardizedEffectSize <- "normal"
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianIndependentSamples", "debug.csv", options)

test_that("Bayesian Equivalence Independent Samples T-Test with informative normal prior", {
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

# Test 7: Informative t prior
test_that("Bayesian Equivalence Independent Samples T-Test with informative t prior", {
  options <- jaspTools::analysisOptions("SummaryStatsTTestEquivalenceBayesianIndependentSamples")
  options$tStatistic <- 2
  options$sampleSizeGroupOne <- 20
  options$sampleSizeGroupTwo <- 20
  options$effectSizeStandardized <- "informative"
  options$informativeStandardizedEffectSize <- "t"
  set.seed(1)
  results <- jaspTools::runAnalysis("SummaryStatsTTestEquivalenceBayesianIndependentSamples", "debug.csv", options)
  table <- results[["results"]][["equivalenceContainer"]][["collection"]][["equivalenceContainer_equivalenceTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("Overlapping (inside vs. all)",
                           "\U003B4 \U02208 I vs. H\u2081", ".", ".",
                           "Overlapping (outside vs. all)",
                           "\U003B4 \U02209 I vs. H\u2081", ".", ".",
                           "Non-overlapping (inside vs. outside)",
                           "\U003B4 \U02208 I vs. \U003B4 \U02209 I", ".", "."),
                      label = "Informative t prior table")
})
