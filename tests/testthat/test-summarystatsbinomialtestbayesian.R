context("Summary Stats Binomial Test Bayesian")

test_that("Main table results match", {
  options <- jaspTools::analysisOptions("SummaryStatsBinomialTestBayesian")
  
  options$successes                           <- 58
  options$failures                            <- 42
  options$betaPriorA                     <- 4
  options$betaPriorB                     <- 2
  options$testValue                           <- "0.2"
  options$bayesFactorType                     <- "BF01"
  options$priorPosteriorPlot               <- FALSE
  options$priorPosteriorPlotAdditionalInfo <- FALSE
  
  results <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  table   <- results[["results"]][["binomialContainer"]][["collection"]][["binomialContainer_bayesianBinomialTable"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list(4.32337507642424e-15, 42, 8.41375589059492e-17, 58, 0.2)
  )
})

test_that("Prior posterior plots match", {
  options <- jaspTools::analysisOptions("SummaryStatsBinomialTestBayesian")
  # without additional information
  options$testValue                           <- "0.5"
  options$successes                           <- 58
  options$failures                            <- 42
  options$priorPosteriorPlot               <- TRUE
  options$priorPosteriorPlotAdditionalInfo <- FALSE
  results  <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-posterior-1")
  
  options$successes                           <- 42
  options$failures                            <- 58
  results  <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-posterior-2")
  
  # with additional information
  options$priorPosteriorPlot               <- TRUE
  options$priorPosteriorPlotAdditionalInfo <- TRUE
  results  <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-posterior-3")
  
  options$successes                           <- 58
  options$failures                            <- 42
  results  <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "prior-posterior-4")
})

test_that("Error message is validation", {
  options <- jaspTools::analysisOptions("SummaryStatsBinomialTestBayesian")
  
  options$successes                           <- 10
  options$failures                            <- 0
  options$betaPriorA                     <- 0.001
  options$betaPriorB                     <- 9999
  options$testValue                           <- "0.5"
  options$alternative                          <- "greater"
  options$priorPosteriorPlot               <- TRUE
  options$priorPosteriorPlotAdditionalInfo <- TRUE
  
  results <- jaspTools::runAnalysis("SummaryStatsBinomialTestBayesian", "debug.csv", options)
  error   <- results[["results"]][["binomialContainer"]][["collection"]][["binomialContainer_priorPosteriorPlot"]][["error"]][["type"]]
  expect_identical(error, "badData")
})
