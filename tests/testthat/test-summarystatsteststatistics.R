context("Summary Statistics Test Statistics")

options <- jaspTools::analysisOptions("SummaryStatsTestStatistics")

test_that("z-test two-sided works", {
  options$testType <- "z"
  options$zStatistic <- 1.96
  options$alternative <- "twoSided"

  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", NULL, options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]

  expect_equal(table[[1]][["testType"]], "z")
  expect_equal(table[[1]][["statistic"]], 1.96, tolerance = 1e-6)
  expect_equal(table[[1]][["pValue"]], pnorm(options$zStatistic, lower.tail = F) * 2, tolerance = 1e-6)
})

test_that("t-test one-sided works", {
  options$testType <- "t"
  options$tStatistic <- 2.0
  options$tDf <- 10
  options$alternative <- "greater"

  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug", options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]

  expect_equal(table[[1]][["testType"]], "t")
  expect_equal(table[[1]][["statistic"]], 2.0, tolerance = 1e-6)
  expect_equal(table[[1]][["df"]], 10)
  expect_equal(table[[1]][["pValue"]], pt(options$tStatistic, options$tDf, lower.tail = F), tolerance = 1e-6)
})

test_that("chi-squared test works", {
  options$testType <- "chi2"
  options$chi2Statistic <- 3.84
  options$chi2Df <- 1

  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug", options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]

  expect_equal(table[[1]][["testType"]], "χ²")
  expect_equal(table[[1]][["statistic"]], 3.84, tolerance = 1e-6)
  expect_equal(table[[1]][["df"]], 1)
  expect_equal(table[[1]][["pValue"]], pchisq(options$chi2Statistic, options$chi2Df, lower.tail = F), tolerance = 1e-6)
})

test_that("f-test works", {
  options$testType <- "f"
  options$fStatistic <- 4.0
  options$fDf1 <- 2
  options$fDf2 <- 10

  results <- jaspTools::runAnalysis("SummaryStatsTestStatistics", "debug", options)
  table <- results[["results"]][["testStatisticsTable"]][["data"]]

  expect_equal(table[[1]][["testType"]], "F")
  expect_equal(table[[1]][["statistic"]], 4.0, tolerance = 1e-6)
  expect_equal(table[[1]][["df1"]], 2)
  expect_equal(table[[1]][["df2"]], 10)
  expect_equal(table[[1]][["pValue"]], pf(options$fStatistic, options$fDf1, options$fDf2, lower.tail = F), tolerance = 1e-6)
})
