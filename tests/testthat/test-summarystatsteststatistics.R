context("Summary Statistics Test Statistics")

options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")

test_that("z-test two-sided works", {
  options$testType <- "z"
  options$zStatistic <- 1.96
  options$alternative <- "twoSided"
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "", options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  
  expect_equal(table[[1]][["testType"]], "z")
  expect_equal(table[[1]][["statistic"]], 1.96, tolerance = 1e-6)
  expect_equal(table[[1]][["pValue"]], 0.04999579, tolerance = 1e-6)
})

test_that("t-test one-sided works", {
  options$testType <- "t"
  options$tStatistic <- 2.0
  options$tDf <- 10
  options$alternative <- "greater"
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "", options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  
  expect_equal(table[[1]][["testType"]], "t")
  expect_equal(table[[1]][["statistic"]], 2.0, tolerance = 1e-6)
  expect_equal(table[[1]][["df"]], "10")
  expect_equal(table[[1]][["pValue"]], 0.03593486, tolerance = 1e-6)
})

test_that("chi-squared test works", {
  options$testType <- "chi2"
  options$chi2Statistic <- 3.84
  options$chi2Df <- 1
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "", options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  
  expect_equal(table[[1]][["testType"]], "χ²")
  expect_equal(table[[1]][["statistic"]], 3.84, tolerance = 1e-6)
  expect_equal(table[[1]][["df"]], "1")
  expect_equal(table[[1]][["pValue"]], 0.05004025, tolerance = 1e-6)
})

test_that("f-test works", {
  options$testType <- "f"
  options$fStatistic <- 4.0
  options$fDf1 <- 2
  options$fDf2 <- 10
  
  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "", options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]
  
  expect_equal(table[[1]][["testType"]], "F")
  expect_equal(table[[1]][["statistic"]], 4.0, tolerance = 1e-6)
  expect_equal(table[[1]][["df"]], "2, 10")
  expect_equal(table[[1]][["pValue"]], 0.05188997, tolerance = 1e-6)
})