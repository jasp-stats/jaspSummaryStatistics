context("Summary Statistics Bayesian Independent Samples T-Test")

options <- jaspTools::analysisOptions("SummaryStatsTTestBayesianIndependentSamples")
options$tStatistic <- 2.3
options$sampleSizeGroupOne <- 20
options$sampleSizeGroupTwo <- 20
options$priorPosteriorPlot <- TRUE
options$bfRobustnessPlotAdditionalInfo <- FALSE
options$alternative <- "less"
options$informativeCauchyLocation <- 1
options$effectSizeStandardized <- "informative"
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestBayesianIndependentSamples", "debug.csv", options)


test_that("Prior and Posterior plot matches", {
  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_priorPosteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior")
})

test_that("Bayesian Independent Samples T-Test table results match", {
  table <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_ttestTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(0.08420871, 0.001761993, 20, 20, 0.986483662535044,
                           2.3))
})

options <- jaspTools::analysisOptions("SummaryStatsTTestBayesianIndependentSamples")
options$alternative <- "less"
options$tStatistic <- 2.3
options$sampleSizeGroupOne <- 20
options$sampleSizeGroupTwo <- 20
options$priorPosteriorPlot <- TRUE
options$bfRobustnessPlotAdditionalInfo <- TRUE
options$bfRobustnessPlot <- TRUE
options$bfRobustnessPlotAdditionalInfo <- TRUE
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestBayesianIndependentSamples", "debug.csv", options)

test_that("Bayes Factor Robustness Check plot matches", {
  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_BayesFactorRobustnessPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "bayes-factor-robustness-check")
})

test_that("Prior and Posterior plot matches", {
  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_priorPosteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-2")
})


options <- jaspTools::analysisOptions("SummaryStatsTTestBayesianIndependentSamples")
options$alternative <- "less"
options$tStatistic <- 2.3
options$sampleSizeGroupOne <- 20
options$sampleSizeGroupTwo <- 20
options$priorPosteriorPlot <- TRUE
options$bfRobustnessPlotAdditionalInfo <- TRUE
options$bfRobustnessPlot <- TRUE
options$bfRobustnessPlotAdditionalInfo <- TRUE
options$bayesFactorType = "BF01"
options$priorPosteriorPlotAdditionalInfo <- TRUE
set.seed(1)
results <- jaspTools::runAnalysis("SummaryStatsTTestBayesianIndependentSamples", "debug.csv", options)


test_that("BF Type Label Switches Correctly Robustness Check", {
  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_BayesFactorRobustnessPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "bayes-factor-robustness-check-2")
})

test_that("BF Type Label Switches Correctly Prior Posterior", {
  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_priorPosteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-3")
})

test_that("Informed priors work", {
  options <- analysisOptions("SummaryStatsTTestBayesianIndependentSamples")

  options$sampleSizeGroupOne     <- 20
  options$sampleSizeGroupTwo     <- 20
  options$tStatistic <- 2
  options$effectSizeStandardized <- "informative"

  reference <- list(
    t      = list(1.45400012678284, 0.000123486895286172, 20, 20, 0.0526850709676671, 2),
    normal = list(2.04756225232945, "NaN", 20, 20, 0.0526850709676671, 2)
  )

  for (informativeStandardizedEffectSize in c("normal", "t")) {

    options$informativeStandardizedEffectSize <- informativeStandardizedEffectSize
    set.seed(1)
    results <- runAnalysis("SummaryStatsTTestBayesianIndependentSamples", NULL, options)
    table <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_ttestTable"]][["data"]]
    jaspTools::expect_equal_tables(table, reference[[informativeStandardizedEffectSize]])

  }

})


test_that("Prior posterior plot agrees with full data analysis", {
  # verified on version https://github.com/jasp-stats/jasp-desktop/commit/c9b1c6a4b540d3c142354fdbf911b2556454dc3d
  # data from Data Library/T-tests/Directed Reading Activities
  # based on https://github.com/jasp-stats/INTERNAL-jasp/issues/1668
  options <- jaspTools::analysisOptions("SummaryStatsTTestBayesianIndependentSamples")
  options$tStatistic <- -2.267
  options$sampleSizeGroupOne <- 23
  options$sampleSizeGroupTwo <- 21
  options$priorPosteriorPlot <- TRUE

  set.seed(1)
  results <- jaspTools::runAnalysis("SummaryStatsTTestBayesianIndependentSamples", "debug.csv", options)

  plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_priorPosteriorPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-and-posterior-verified-on-data")
})

test_that("Robustness check shows the maximum BF01 when BF01 is chosen", {
  # expected values: BayesFactor::ttest.tstat() over the plot's 400 prior widths from 0.0005 to 1.5.
  # The case of jasp-issues#1404 (t = 0.42, n = 99 and 119): max BF10 is 0.9973 at r = 0.0005 and
  # max BF01 = 1 / min BF10 is 12.77 at r = 1.5.
  # t = 1.9, n = 20 and 20: BF10 is above 1 for small prior widths and below 1 near r = 1.5,
  # max BF01 is 1.2 at r = 1.5.
  getMaxPoint <- function(results) {
    plotName <- results[["results"]][["ttestContainer"]][["collection"]][["ttestContainer_BayesFactorRobustnessPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    for (subplot in testPlot$subplots) for (layer in subplot$layers)
      if (is.data.frame(layer$data) && "label2" %in% names(layer$data))
        return(layer$data[1, ])
  }
  options <- jaspTools::analysisOptions("SummaryStatsTTestBayesianIndependentSamples")
  options$tStatistic <- 0.42
  options$sampleSizeGroupOne <- 99
  options$sampleSizeGroupTwo <- 119
  options$bfRobustnessPlot <- TRUE
  options$bfRobustnessPlotAdditionalInfo <- TRUE

  options$bayesFactorType <- "BF10"
  point <- getMaxPoint(jaspTools::runAnalysis("SummaryStatsTTestBayesianIndependentSamples", NULL, options))
  expect_identical(as.character(point$label2), "0.9973~at~r==5e-04")

  options$bayesFactorType <- "BF01"
  point <- getMaxPoint(jaspTools::runAnalysis("SummaryStatsTTestBayesianIndependentSamples", NULL, options))
  expect_identical(as.character(point$label2), "12.77~at~r==1.5")
  expect_equal(exp(point$y), 12.77, tolerance = 1e-3)

  options$tStatistic <- 1.9
  options$sampleSizeGroupOne <- 20
  options$sampleSizeGroupTwo <- 20
  point <- getMaxPoint(jaspTools::runAnalysis("SummaryStatsTTestBayesianIndependentSamples", NULL, options))
  expect_identical(as.character(point$label2), "1.2~at~r==1.5")
  expect_equal(exp(point$y), 1.2, tolerance = 1e-3)
})
