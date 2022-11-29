context("Summary Statistics Bayesian Paired Samples T-Test")

options <- jaspTools::analysisOptions("SummaryStatsTTestBayesianPairedSamples")
options$tStatistic <- 2.3
options$sampleSize <- 20
options$priorPosteriorPlot <- TRUE
options$bfRobustnessPlot <- TRUE
options$alternative <- "less"
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestBayesianPairedSamples", "debug.csv", options)


test_that("Bayes Factor Robustness Check plot matches", {
  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_BayesFactorRobustnessPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "bayes-factor-robustness-check")
})

test_that("Bayesian Paired Samples T-Test table results match", {
  table <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_ttestTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(0.0821009262649839, 0.021753325120914, 20, 0.983523708768303,
                           2.3))
})

test_that("Default Prior and Posterior plot matches", {
  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_priorPosteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior")
})

options <- jaspTools::analysisOptions("SummaryStatsTTestBayesianPairedSamples")
options$tStatistic <- 2.3
options$sampleSize <- 20
options$priorPosteriorPlot <- TRUE
options$bfRobustnessPlotAdditionalInfo <- FALSE
options$alternative <- "less"
options$informativeCauchyLocation <- 1
options$effectSizeStandardized <- "informative"
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestBayesianPairedSamples", "debug.csv", options)


test_that("Bayesian Paired Samples T-Test table results match", {
  table <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_ttestTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(0.0644349416204716, 0.000247553379975798, 20, 0.983523708768303,
                           2.3))
})

test_that("Informative Cauchy Prior and Posterior plot matches", {
  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_priorPosteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-2")
})
