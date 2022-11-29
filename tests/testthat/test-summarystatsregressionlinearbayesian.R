context("Summary Statistics Bayesian Linear Regression")


getMainTable <- function(results)
  results[["results"]][["mainContainer"]][["collection"]][["mainContainer_regressionTable"]][["data"]]

getRobustnessPlot <- function(results) {
  plotName <- results[["results"]][["mainContainer"]][["collection"]][["mainContainer_bfRobustnessPlot"]][["data"]]
  testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
  return(testPlot)
}


test_that("Main table results match with one model", {
  set.seed(0)
  options <- jaspTools::analysisOptions("SummaryStatsRegressionLinearBayesian")
  options$sampleSize                    <- 51
  options$nullNumberOfCovariates        <- 0
  options$nullUnadjustedRSquared        <- 0
  options$alternativeNumberOfCovariates <- 4
  options$alternativeUnadjustedRSquared <- 0.82
  options$priorRScale                    <- 0.5
  options$bayesFactorType               <- "LogBF10"
  results <- jaspTools::runAnalysis("SummaryStatsRegressionLinearBayesian", "debug.csv", options)

  table <- getMainTable(results)
  # fill in expected values
  jaspTools::expect_equal_tables(table, list(31.7268858756927, 0.82, 1.40664186301779e-06, 4, 51))
})

test_that("Main table results match with model comparison", {
  set.seed(0)
  options <- jaspTools::analysisOptions("SummaryStatsRegressionLinearBayesian")
  options$sampleSize                    <- 51
  options$nullNumberOfCovariates        <- 2
  options$nullUnadjustedRSquared        <- 0.62
  options$alternativeNumberOfCovariates <- 4
  options$alternativeUnadjustedRSquared <- 0.82
  options$priorRScale                    <- 0.5
  options$bayesFactorType               <- "LogBF10"
  results <- jaspTools::runAnalysis("SummaryStatsRegressionLinearBayesian", "debug.csv", options)

  table <- getMainTable(results)
  # fill in expected values
  jaspTools::expect_equal_tables(table, list(-12.9889, 0.62, 2.01408039564443e-06, 2, "Null model",
                                  12.9889, 0.82, 1.40664186301779e-06, 4, "Alternative model"
                                  ))
})

test_that("Main table and plots match without additional info", {
  options <- jaspTools::analysisOptions("SummaryStatsRegressionLinearBayesian")
  options$bayesFactorType <- "LogBF10"
  options$alternativeNumberOfCovariates <- 5
  options$nullNumberOfCovariates <- 4
  options$bfRobustnessPlot <- TRUE
  options$bfRobustnessPlotAdditionalInfo <- FALSE
  options$sampleSize <- 750
  options$alternativeUnadjustedRSquared <- 0.55
  options$nullUnadjustedRSquared <- 0.45
  set.seed(1)
  results <- jaspTools::runAnalysis("SummaryStatsRegressionLinearBayesian", "debug.csv", options)

  table <- getMainTable(results)
  jaspTools::expect_equal_tables(table,
                      list(-71.56048, 0.45, 6.09707810829571e-07, 4, "Null model",
                           71.56048, 0.55, 9.79848723927088e-06, 5, "Alternative model"))

  testPlot <- getRobustnessPlot(results)
  jaspTools::expect_equal_plots(testPlot, "robustness-plot")

})

test_that("Main table and plots match with additional info", {
  options <- jaspTools::analysisOptions("SummaryStatsRegressionLinearBayesian")
  options$bfRobustnessPlot <- TRUE
  set.seed(1)
  results <- jaspTools::runAnalysis("SummaryStatsRegressionLinearBayesian", "debug.csv", options)

  table <- getMainTable(results)
  jaspTools::expect_equal_tables(table,
                      list(0.651407436025229, 0, 2.50272800102564e-05, 1, 3))

  testPlot <- getRobustnessPlot(results)
  jaspTools::expect_equal_plots(testPlot, "robustness-additional-info-plot")

})


