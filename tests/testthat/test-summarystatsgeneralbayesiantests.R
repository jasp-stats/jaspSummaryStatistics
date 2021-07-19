context("SummaryStatsGeneralBayesianTests")

# tests all possible priors - print & prior/predictive/posterior plots
{
  options <- analysisOptions("SummaryStatsGeneralBayesianTests")
  options$.meta <- list(dataD = list(isRCode = TRUE), dataMean = list(isRCode = TRUE),
                        dataSd = list(isRCode = TRUE), dataT = list(isRCode = TRUE),
                        nullParA = list(isRCode = TRUE), nullParAlpha = list(isRCode = TRUE),
                        nullParB = list(isRCode = TRUE), nullParBeta = list(isRCode = TRUE),
                        nullParDf = list(isRCode = TRUE), nullParLocation = list(
                          isRCode = TRUE), nullParMean = list(isRCode = TRUE),
                        nullParScale = list(isRCode = TRUE), nullParScale2 = list(
                          isRCode = TRUE), nullTruncationLower = list(isRCode = TRUE),
                        nullTruncationUpper = list(isRCode = TRUE), parA = list(isRCode = TRUE),
                        parAlpha = list(isRCode = TRUE), parB = list(isRCode = TRUE),
                        parBeta = list(isRCode = TRUE), parDf = list(isRCode = TRUE),
                        parLocation = list(isRCode = TRUE), parMean = list(isRCode = TRUE),
                        parScale = list(isRCode = TRUE), parScale2 = list(isRCode = TRUE),
                        truncationLower = list(isRCode = TRUE), truncationUpper = list(
                          isRCode = TRUE))
  options$dataD <- "0"
  options$dataMean <- "0"
  options$dataSd <- "1"
  options$dataT <- "0"
  options$nullParA <- "0"
  options$nullParAlpha <- "1"
  options$nullParB <- "1"
  options$nullParBeta <- "1"
  options$nullParDf <- "2"
  options$nullParLocation <- "0"
  options$nullParMean <- "0"
  options$nullParScale <- "1"
  options$nullParScale2 <- "1"
  options$nullTruncationLower <- "-Inf"
  options$nullTruncationUpper <- "Inf"
  options$plotLikelihood <- TRUE
  options$plotPosteriors <- TRUE
  options$plotPosteriorsPriors <- TRUE
  options$plotPredictions <- TRUE
  options$plotPriors <- TRUE
  options$priorsAlt <- list(list(name = "#", parA = "0", parAlpha = "1", parB = "1",
                                 parBeta = "1", parDf = "2", parLocation = "0", parMean = "0",
                                 parScale = "1", parScale2 = "1", truncationLower = "-Inf",
                                 truncationUpper = "Inf", type = "normal"), list(name = "#2",
                                                                                 parA = "0", parAlpha = "1", parB = "1", parBeta = "1", parDf = "2",
                                                                                 parLocation = "0", parMean = "0", parScale = "1", parScale2 = "1",
                                                                                 truncationLower = "-Inf", truncationUpper = "Inf", type = "t"),
                            list(name = "#3", parA = "0", parAlpha = "1", parB = "1",
                                 parBeta = "1", parDf = "2", parLocation = "0", parMean = "0",
                                 parScale = "1", parScale2 = "1", truncationLower = "-Inf",
                                 truncationUpper = "Inf", type = "cauchy"), list(name = "#4",
                                                                                 parA = "0", parAlpha = "1", parB = "1", parBeta = "1",
                                                                                 parDf = "2", parLocation = "0", parMean = "0", parScale = "1",
                                                                                 parScale2 = "1", truncationLower = "-Inf", truncationUpper = "Inf",
                                                                                 type = "beta"), list(name = "#5", parA = "0", parAlpha = "1",
                                                                                                      parB = "1", parBeta = "1", parDf = "2", parLocation = "0",
                                                                                                      parMean = "0", parScale = "1", parScale2 = "1", truncationLower = "-Inf",
                                                                                                      truncationUpper = "Inf", type = "uniform"), list(name = "#6",
                                                                                                                                                       parA = "0", parAlpha = "1", parB = "1", parBeta = "1",
                                                                                                                                                       parDf = "2", parLocation = "0", parMean = "0", parScale = "1",
                                                                                                                                                       parScale2 = "1", truncationLower = "-Inf", truncationUpper = "Inf",
                                                                                                                                                       type = "spike"))
  set.seed(1)
  results <- runAnalysis("SummaryStatsGeneralBayesianTests", "", options)


  test_that("Likelihood plot matches", {
    plotName <- results[["results"]][["likelihoodPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "likelihood-test1")
  })

  test_that("Normal(0, 1) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot1"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "normal-0-1-posterior-test1")
  })

  test_that("Student-t(0, 1, 2) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot2"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "student-t-0-1-2-posterior-test1")
  })

  test_that("Cauchy(0, 1) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot3"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "cauchy-0-1-posterior-test1")
  })

  test_that("Beta(1, 1) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot4"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "beta-1-1-posterior-test1")
  })

  test_that("Uniform(0, 1) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot5"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "uniform-0-1-posterior-test1")
  })

  test_that("Spike(0) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot6"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "spike-0-posterior-test1")
  })

  test_that("Null hypothesis plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_priorNullPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "null-hypothesis-posterior-test1")
  })

  test_that("Normal(0, 1) plot matches", {
    plotName <- results[["results"]][["predictionsPlot"]][["collection"]][["predictionsPlot_predictionsAltPlots"]][["collection"]][["predictionsPlot_predictionsAltPlots_predictionsAltPlot1"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "normal-0-1-predictive-test1")
  })

  test_that("Student-t(0, 1, 2) plot matches", {
    plotName <- results[["results"]][["predictionsPlot"]][["collection"]][["predictionsPlot_predictionsAltPlots"]][["collection"]][["predictionsPlot_predictionsAltPlots_predictionsAltPlot2"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "student-t-0-1-2-predictive-test1")
  })

  test_that("Cauchy(0, 1) plot matches", {
    plotName <- results[["results"]][["predictionsPlot"]][["collection"]][["predictionsPlot_predictionsAltPlots"]][["collection"]][["predictionsPlot_predictionsAltPlots_predictionsAltPlot3"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "cauchy-0-1-predictive-test1")
  })

  test_that("Beta(1, 1) plot matches", {
    plotName <- results[["results"]][["predictionsPlot"]][["collection"]][["predictionsPlot_predictionsAltPlots"]][["collection"]][["predictionsPlot_predictionsAltPlots_predictionsAltPlot4"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "beta-1-1-predictive-test1")
  })

  test_that("Uniform(0, 1) plot matches", {
    plotName <- results[["results"]][["predictionsPlot"]][["collection"]][["predictionsPlot_predictionsAltPlots"]][["collection"]][["predictionsPlot_predictionsAltPlots_predictionsAltPlot5"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "uniform-0-1-predictive-test1")
  })

  test_that("Spike(0) plot matches", {
    plotName <- results[["results"]][["predictionsPlot"]][["collection"]][["predictionsPlot_predictionsAltPlots"]][["collection"]][["predictionsPlot_predictionsAltPlots_predictionsAltPlot6"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "spike-0-predictive-test1")
  })

  test_that("Null hypothesis plot matches", {
    plotName <- results[["results"]][["predictionsPlot"]][["collection"]][["predictionsPlot_predictionsNullPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "null-hypothesis-predictive-test1")
  })

  test_that("Null hypothesis plot matches", {
    plotName <- results[["results"]][["priorsPlot"]][["collection"]][["priorsPlot_priorNullPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "null-hypothesis-prior-test1")
  })

  test_that("Normal(0, 1) plot matches", {
    plotName <- results[["results"]][["priorsPlot"]][["collection"]][["priorsPlot_priorsAltPlots"]][["collection"]][["priorsPlot_priorsAltPlots_priorAltPlot1"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "normal-0-1-prior-test1")
  })

  test_that("Student-t(0, 1, 2) plot matches", {
    plotName <- results[["results"]][["priorsPlot"]][["collection"]][["priorsPlot_priorsAltPlots"]][["collection"]][["priorsPlot_priorsAltPlots_priorAltPlot2"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "student-t-0-1-2-prior-test1")
  })

  test_that("Cauchy(0, 1) plot matches", {
    plotName <- results[["results"]][["priorsPlot"]][["collection"]][["priorsPlot_priorsAltPlots"]][["collection"]][["priorsPlot_priorsAltPlots_priorAltPlot3"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "cauchy-0-1-prior-test1")
  })

  test_that("Beta(1, 1) plot matches", {
    plotName <- results[["results"]][["priorsPlot"]][["collection"]][["priorsPlot_priorsAltPlots"]][["collection"]][["priorsPlot_priorsAltPlots_priorAltPlot4"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "beta-1-1-prior-test1")
  })

  test_that("Uniform(0, 1) plot matches", {
    plotName <- results[["results"]][["priorsPlot"]][["collection"]][["priorsPlot_priorsAltPlots"]][["collection"]][["priorsPlot_priorsAltPlots_priorAltPlot5"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "uniform-0-1-prior-test1")
  })

  test_that("Spike(0) plot matches", {
    plotName <- results[["results"]][["priorsPlot"]][["collection"]][["priorsPlot_priorsAltPlots"]][["collection"]][["priorsPlot_priorsAltPlots_priorAltPlot6"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "spike-0-prior-test1")
  })

  test_that("Model Summary table results match", {
    table <- results[["results"]][["summaryTable"]][["data"]]
    jaspTools::expect_equal_tables(table,
                                   list(0.707106781332586, "Normal(0, 1)", 0.603450159840562, "Student-t(0, 1, 2)",
                                        0.523156583731265, "Cauchy(0, 1)", 0.855624391892149, "Beta(1, 1)",
                                        0.855624391892149, "Uniform(0, 1)", 1, "Spike(0)"))
  })
}

# test student-t likelihood
{
  options <- analysisOptions("SummaryStatsGeneralBayesianTests")
  options$.meta <- list(dataD = list(isRCode = TRUE), dataMean = list(isRCode = TRUE),
                        dataSd = list(isRCode = TRUE), dataT = list(isRCode = TRUE),
                        nullParA = list(isRCode = TRUE), nullParAlpha = list(isRCode = TRUE),
                        nullParB = list(isRCode = TRUE), nullParBeta = list(isRCode = TRUE),
                        nullParDf = list(isRCode = TRUE), nullParLocation = list(
                          isRCode = TRUE), nullParMean = list(isRCode = TRUE),
                        nullParScale = list(isRCode = TRUE), nullParScale2 = list(
                          isRCode = TRUE), nullTruncationLower = list(isRCode = TRUE),
                        nullTruncationUpper = list(isRCode = TRUE), parA = list(isRCode = TRUE),
                        parAlpha = list(isRCode = TRUE), parB = list(isRCode = TRUE),
                        parBeta = list(isRCode = TRUE), parDf = list(isRCode = TRUE),
                        parLocation = list(isRCode = TRUE), parMean = list(isRCode = TRUE),
                        parScale = list(isRCode = TRUE), parScale2 = list(isRCode = TRUE),
                        truncationLower = list(isRCode = TRUE), truncationUpper = list(
                          isRCode = TRUE))
  options$bayesFactorType <- "BF01"
  options$dataD <- "0"
  options$dataMean <- "0.5"
  options$dataSd <- "1"
  options$dataT <- "0"
  options$likelihood <- "t"
  options$nullParA <- "0"
  options$nullParAlpha <- "1"
  options$nullParB <- "1"
  options$nullParBeta <- "1"
  options$nullParDf <- "2"
  options$nullParLocation <- "0"
  options$nullParMean <- "0"
  options$nullParScale <- "1"
  options$nullParScale2 <- "1"
  options$nullTruncationLower <- "-Inf"
  options$nullTruncationUpper <- "Inf"
  options$nullType <- "normal"
  options$plotLikelihood <- TRUE
  options$plotPosteriors <- TRUE
  options$priorsAlt <- list(list(name = "#", parA = "0", parAlpha = "1", parB = "1",
                                 parBeta = "1", parDf = "2", parLocation = "0", parMean = "0",
                                 parScale = "1", parScale2 = "1", truncationLower = "0", truncationUpper = "Inf",
                                 type = "normal"), list(name = "#2", parA = "0", parAlpha = "1",
                                                        parB = "1", parBeta = "1", parDf = "2", parLocation = "0",
                                                        parMean = "0", parScale = "1", parScale2 = "1", truncationLower = "-Inf",
                                                        truncationUpper = "Inf", type = "spike"), list(name = "#3",
                                                                                                       parA = "0", parAlpha = "1", parB = "1", parBeta = "1", parDf = "2",
                                                                                                       parLocation = "0", parMean = "0", parScale = "1", parScale2 = "1",
                                                                                                       truncationLower = "-Inf", truncationUpper = "Inf", type = "uniform"))
  set.seed(1)
  results <- runAnalysis("SummaryStatsGeneralBayesianTests", "", options)


  test_that("Likelihood plot matches", {
    plotName <- results[["results"]][["likelihoodPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "likelihood-test2")
  })

  test_that("Normal(0, 1)[0,Inf] plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot1"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "normal-0-1-0-inf-posterior-test2")
  })

  test_that("Spike(0) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot2"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "spike-0-posterior-test2")
  })

  test_that("Uniform(0, 1) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot3"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "uniform-0-1-posterior-test2")
  })

  test_that("Null hypothesis plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_priorNullPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "null-hypothesis-posterior-test2")
  })

  test_that("Model Summary table results match", {
    table <- results[["results"]][["summaryTable"]][["data"]]
    jaspTools::expect_equal_tables(table,
                                   list(0.783756975624425, "Normal(0, 1)[0,Inf]", 0.754502380085506, "Spike(0)",
                                        0.691711889090138, "Uniform(0, 1)"))
  })
}

# test binomial likelihood (especially whether the range of figures is bounded)
{
  options <- analysisOptions("SummaryStatsGeneralBayesianTests")
  options$.meta <- list(dataD = list(isRCode = TRUE), dataMean = list(isRCode = TRUE),
                        dataSd = list(isRCode = TRUE), dataT = list(isRCode = TRUE),
                        nullParA = list(isRCode = TRUE), nullParAlpha = list(isRCode = TRUE),
                        nullParB = list(isRCode = TRUE), nullParBeta = list(isRCode = TRUE),
                        nullParDf = list(isRCode = TRUE), nullParLocation = list(
                          isRCode = TRUE), nullParMean = list(isRCode = TRUE),
                        nullParScale = list(isRCode = TRUE), nullParScale2 = list(
                          isRCode = TRUE), nullTruncationLower = list(isRCode = TRUE),
                        nullTruncationUpper = list(isRCode = TRUE), parA = list(isRCode = TRUE),
                        parAlpha = list(isRCode = TRUE), parB = list(isRCode = TRUE),
                        parBeta = list(isRCode = TRUE), parDf = list(isRCode = TRUE),
                        parLocation = list(isRCode = TRUE), parMean = list(isRCode = TRUE),
                        parScale = list(isRCode = TRUE), parScale2 = list(isRCode = TRUE),
                        truncationLower = list(isRCode = TRUE), truncationUpper = list(
                          isRCode = TRUE))
  options$bayesFactorType <- "LogBF10"
  options$dataD <- "0"
  options$dataMean <- "0.5"
  options$dataSd <- "1"
  options$dataSuccesses <- 9
  options$dataT <- "0"
  options$likelihood <- "binomial"
  options$nullParA <- "0"
  options$nullParAlpha <- "1"
  options$nullParB <- "1"
  options$nullParBeta <- "1"
  options$nullParDf <- "2"
  options$nullParLocation <- "0"
  options$nullParMean <- "0"
  options$nullParScale <- "1"
  options$nullParScale2 <- "1"
  options$nullTruncationLower <- "-Inf"
  options$nullTruncationUpper <- "Inf"
  options$nullType <- "beta"
  options$plotLikelihood <- TRUE
  options$plotPosteriors <- TRUE
  options$priorsAlt <- list(list(name = "#", parA = "0", parAlpha = "1", parB = "1",
                                 parBeta = "1", parDf = "2", parLocation = "0", parMean = "1",
                                 parScale = "1", parScale2 = "1", truncationLower = "0", truncationUpper = "1",
                                 type = "normal"), list(name = "#2", parA = "0", parAlpha = "1",
                                                        parB = "1", parBeta = "1", parDf = "2", parLocation = ".99",
                                                        parMean = "0", parScale = "1", parScale2 = "1", truncationLower = "-Inf",
                                                        truncationUpper = "Inf", type = "spike"))
  set.seed(1)
  results <- runAnalysis("SummaryStatsGeneralBayesianTests", "", options)


  test_that("Likelihood plot matches", {
    plotName <- results[["results"]][["likelihoodPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "likelihood-test3")
  })

  test_that("Normal(1, 1)[0,1] plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot1"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "normal-1-1-0-1-posterior-test3")
  })

  test_that("Spike(0.99) plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_posteriorsAltPlots"]][["collection"]][["posteriorsPlot_posteriorsAltPlots_priorAltPlot2"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "spike-0-99-posterior-test3")
  })

  test_that("Null hypothesis plot matches", {
    plotName <- results[["results"]][["posteriorsPlot"]][["collection"]][["posteriorsPlot_priorNullPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "null-hypothesis-posterior-test3")
  })

  test_that("Model Summary table results match", {
    table <- results[["results"]][["summaryTable"]][["data"]]
    jaspTools::expect_equal_tables(table,
                                   list(0.136960751151379, "Normal(1, 1)[0,1]", 0.00485715712281256, "Spike(0.99)"
                                   ))
  })
}

# non-central d
{
  options <- analysisOptions("SummaryStatsGeneralBayesianTests")
  options$.meta <- list(dataD = list(isRCode = TRUE), dataMean = list(isRCode = TRUE),
                        dataSd = list(isRCode = TRUE), dataT = list(isRCode = TRUE),
                        nullParA = list(isRCode = TRUE), nullParAlpha = list(isRCode = TRUE),
                        nullParB = list(isRCode = TRUE), nullParBeta = list(isRCode = TRUE),
                        nullParDf = list(isRCode = TRUE), nullParLocation = list(
                          isRCode = TRUE), nullParMean = list(isRCode = TRUE),
                        nullParScale = list(isRCode = TRUE), nullParScale2 = list(
                          isRCode = TRUE), nullTruncationLower = list(isRCode = TRUE),
                        nullTruncationUpper = list(isRCode = TRUE), parA = list(isRCode = TRUE),
                        parAlpha = list(isRCode = TRUE), parB = list(isRCode = TRUE),
                        parBeta = list(isRCode = TRUE), parDf = list(isRCode = TRUE),
                        parLocation = list(isRCode = TRUE), parMean = list(isRCode = TRUE),
                        parScale = list(isRCode = TRUE), parScale2 = list(isRCode = TRUE),
                        truncationLower = list(isRCode = TRUE), truncationUpper = list(
                          isRCode = TRUE))
  options$dataD <- "0"
  options$dataMean <- "0.5"
  options$dataSd <- "1"
  options$dataSuccesses <- 9
  options$dataT <- "0"
  options$likelihood <- "nonCentralD"
  options$nullParA <- "0"
  options$nullParAlpha <- "1"
  options$nullParB <- "1"
  options$nullParBeta <- "1"
  options$nullParDf <- "2"
  options$nullParLocation <- "0"
  options$nullParMean <- "0"
  options$nullParScale <- "1"
  options$nullParScale2 <- "1"
  options$nullTruncationLower <- "-Inf"
  options$nullTruncationUpper <- "Inf"
  options$nullType <- "cauchy"
  options$plotLikelihood <- TRUE
  options$priorsAlt <- list(list(name = "#", parA = "0", parAlpha = "1", parB = "1",
                                 parBeta = "1", parDf = "2", parLocation = "0", parMean = "1",
                                 parScale = "1", parScale2 = "1", truncationLower = "-Inf",
                                 truncationUpper = "Inf", type = "cauchy"), list(name = "#2",
                                                                                 parA = "0", parAlpha = "1", parB = "1", parBeta = "1", parDf = "2",
                                                                                 parLocation = ".99", parMean = "0", parScale = "1", parScale2 = "1",
                                                                                 truncationLower = "-Inf", truncationUpper = "Inf", type = "spike"))
  set.seed(1)
  results <- runAnalysis("SummaryStatsGeneralBayesianTests", "", options)


  test_that("Likelihood plot matches", {
    plotName <- results[["results"]][["likelihoodPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "likelihood-test4")
  })

  test_that("Model Summary table results match", {
    table <- results[["results"]][["summaryTable"]][["data"]]
    jaspTools::expect_equal_tables(table,
                                   list(1, "Cauchy(0, 1)", 0.0320362390728735, "Spike(0.99)"))
  })
}

# and non-central t
{
  options <- analysisOptions("SummaryStatsGeneralBayesianTests")
  options$.meta <- list(dataD = list(isRCode = TRUE), dataMean = list(isRCode = TRUE),
                        dataSd = list(isRCode = TRUE), dataT = list(isRCode = TRUE),
                        nullParA = list(isRCode = TRUE), nullParAlpha = list(isRCode = TRUE),
                        nullParB = list(isRCode = TRUE), nullParBeta = list(isRCode = TRUE),
                        nullParDf = list(isRCode = TRUE), nullParLocation = list(
                          isRCode = TRUE), nullParMean = list(isRCode = TRUE),
                        nullParScale = list(isRCode = TRUE), nullParScale2 = list(
                          isRCode = TRUE), nullTruncationLower = list(isRCode = TRUE),
                        nullTruncationUpper = list(isRCode = TRUE), parA = list(isRCode = TRUE),
                        parAlpha = list(isRCode = TRUE), parB = list(isRCode = TRUE),
                        parBeta = list(isRCode = TRUE), parDf = list(isRCode = TRUE),
                        parLocation = list(isRCode = TRUE), parMean = list(isRCode = TRUE),
                        parScale = list(isRCode = TRUE), parScale2 = list(isRCode = TRUE),
                        truncationLower = list(isRCode = TRUE), truncationUpper = list(
                          isRCode = TRUE))
  options$dataD <- "0"
  options$dataDf <- 10
  options$dataMean <- "0.5"
  options$dataSd <- "1"
  options$dataSuccesses <- 9
  options$dataT <- "0"
  options$likelihood <- "nonCentralT"
  options$nullParA <- "0"
  options$nullParAlpha <- "1"
  options$nullParB <- "1"
  options$nullParBeta <- "1"
  options$nullParDf <- "2"
  options$nullParLocation <- "2/4"
  options$nullParMean <- "0"
  options$nullParScale <- "1"
  options$nullParScale2 <- "1"
  options$nullTruncationLower <- "-Inf"
  options$nullTruncationUpper <- "Inf"
  options$plotLikelihood <- TRUE
  options$priorsAlt <- list(list(name = "#", parA = "0", parAlpha = "1", parB = "1",
                                 parBeta = "1", parDf = "2", parLocation = "0", parMean = "1",
                                 parScale = "1", parScale2 = "1", truncationLower = "-Inf",
                                 truncationUpper = "Inf", type = "uniform"), list(name = "#2",
                                                                                  parA = "0", parAlpha = "1", parB = "1", parBeta = "1", parDf = "2",
                                                                                  parLocation = "1/2", parMean = "0", parScale = "1", parScale2 = "1",
                                                                                  truncationLower = "-Inf", truncationUpper = "Inf", type = "spike"))
  set.seed(1)
  results <- runAnalysis("SummaryStatsGeneralBayesianTests", "", options)


  test_that("Likelihood plot matches", {
    plotName <- results[["results"]][["likelihoodPlot"]][["data"]]
    testPlot <- results[["state"]][["figures"]][[plotName]][["obj"]]
    jaspTools::expect_equal_plots(testPlot, "likelihood-test5")
  })

  test_that("Model Summary table results match", {
    table <- results[["results"]][["summaryTable"]][["data"]]
    jaspTools::expect_equal_tables(table,
                                   list(0.969549456078832, "Uniform(0, 1)", 1, "Spike(0.5)"))
  })
}
