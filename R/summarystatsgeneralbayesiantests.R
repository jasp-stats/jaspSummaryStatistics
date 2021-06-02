#
# Copyright (C) 2013-2018 University of Amsterdam
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

SummaryStatsGeneralBayesianTests <- function(jaspResults, dataset = NULL, options, ...) {

  # set likelihood
  .bayesianTestsSetLikelihood(jaspResults, options)

  # set priors
  .bayesianTestsSetPriors(jaspResults, options)

  # main table
  .bayesianTestsSummaryTable(jaspResults, options)

  # figures
  if (options[["plotPriors"]])
    .bayesianTestsPriorsPlot(jaspResults, options)

  if (options[["plotPredictions"]])
    .bayesianTestsPredictionsPlot(jaspResults, options)

  if (options[["plotLikelihood"]])
    .bayesianTestsLikelihoodPlot(jaspResults, options)

  if (options[["plotPosteriors"]])
    .bayesianTestsPosteriorsPlot(jaspResults, options)

  return()
}

.bayesianTestsDependenciesPriors <- c("priorsAlt", paste0("null", c("ParA", "ParAlpha", "ParB", "ParBeta", "ParDf", "ParLocation", "ParMean", "ParScale", "ParScale2", "TruncationLower", "TruncationUpper", "Type")))
.bayesianTestsDependenciesData   <- c("likelihood", "dataMean", "dataSd", "dataDf", "dataT", "dataD", "dataObservations", "dataSuccesses")

.bayesianTestsSetPriors       <- function(jaspResults, options) {

  if (!is.null(jaspResults[["priors"]]))
    return()

  priors <- createJaspState()
  priors$dependOn(.bayesianTestsDependenciesPriors)
  jaspResults[["priors"]] <- priors


  priorNull <- .bayesianTestsOptions2Priors(.bayesianTestsNull2List(options))
  priorsAlt <- list()
  for (i in seq_along(options[["priorsAlt"]])) {
    priorsAlt[[i]] <- .bayesianTestsOptions2Priors(options[["priorsAlt"]][[i]])
  }

  priors[["object"]] <- list(
    null = priorNull,
    alt  = priorsAlt
  )

  return()
}
.bayesianTestsSetLikelihood   <- function(jaspResults, options) {

  if (!is.null(jaspResults[["likelihood"]]))
    return()

  likelihood <- createJaspState()
  likelihood$dependOn(.bayesianTestsDependenciesData)
  jaspResults[["likelihood"]] <- likelihood


  likelihood[["object"]] <- switch(
    options[["likelihood"]],
    "normal" = bayesplay::likelihood(
      family = "normal",
      mean   = jaspBase:::.parseRCodeInOptions(options[["dataMean"]]),
      sd     = jaspBase:::.parseRCodeInOptions(options[["dataSd"]])
    ),
    "t" = bayesplay::likelihood(
      family = "student_t",
      mean   = jaspBase:::.parseRCodeInOptions(options[["dataMean"]]),
      sd     = jaspBase:::.parseRCodeInOptions(options[["dataSd"]]),
      df     = jaspBase:::.parseRCodeInOptions(options[["dataDf"]])
    ),
    "nonCentralT" = bayesplay::likelihood(
      family = "noncentral_t",
      t      = jaspBase:::.parseRCodeInOptions(options[["dataT"]]),
      df     = jaspBase:::.parseRCodeInOptions(options[["dataDf"]])
    ),
    "nonCentralD" = bayesplay::likelihood(
      family = "noncentral_d",
      d      = jaspBase:::.parseRCodeInOptions(options[["dataD"]]),
      n      = jaspBase:::.parseRCodeInOptions(options[["dataObservations"]])
    ),
    "binomial" = bayesplay::likelihood(
      family = "binomial",
      successes = jaspBase:::.parseRCodeInOptions(options[["dataSuccesses"]]),
      trials    = jaspBase:::.parseRCodeInOptions(options[["dataObservations"]])
    )
  )

  return()
}
.bayesianTestsNull2List       <- function(options) {

  return(list(
      "parA"              = options[["nullParA"]],
      "parAlpha"          = options[["nullParAlpha"]],
      "parB"              = options[["nullParB"]],
      "parBeta"           = options[["nullParBeta"]],
      "parDf"             = options[["nullParDf"]],
      "parLocation"       = options[["nullParLocation"]],
      "parMean"           = options[["nullParMean"]],
      "parScale"          = options[["nullParScale"]],
      "parScale2"         = options[["nullParScale2"]],
      "truncationLower"   = options[["nullTruncationLower"]],
      "truncationUpper"   = options[["nullTruncationUpper"]],
      "type"              = options[["nullType"]]
  ))
}
.bayesianTestsOptions2Priors  <- function(priorOptions) {

  newPrior <- switch(
    priorOptions[["type"]],
    "normal" = bayesplay::prior(
      family = "normal",
      mean   = jaspBase:::.parseRCodeInOptions(priorOptions[["parMean"]]),
      sd     = jaspBase:::.parseRCodeInOptions(priorOptions[["parScale"]]),
      range  = c(
        jaspBase:::.parseRCodeInOptions(priorOptions[["truncationLower"]]),
        jaspBase:::.parseRCodeInOptions(priorOptions[["truncationUpper"]])
    )),
    "t" = bayesplay::prior(
      family = "student_t",
      mean   = jaspBase:::.parseRCodeInOptions(priorOptions[["parMean"]]),
      sd     = jaspBase:::.parseRCodeInOptions(priorOptions[["parScale"]]),
      df     = jaspBase:::.parseRCodeInOptions(priorOptions[["parDf"]]),
      range  = c(
        jaspBase:::.parseRCodeInOptions(priorOptions[["truncationLower"]]),
        jaspBase:::.parseRCodeInOptions(priorOptions[["truncationUpper"]])
    )),
    "cauchy" = bayesplay::prior(
      family   = "cauchy",
      location = jaspBase:::.parseRCodeInOptions(priorOptions[["parLocation"]]),
      scale    = jaspBase:::.parseRCodeInOptions(priorOptions[["parScale2"]]),
      range    = c(
        jaspBase:::.parseRCodeInOptions(priorOptions[["truncationLower"]]),
        jaspBase:::.parseRCodeInOptions(priorOptions[["truncationUpper"]])
    )),
    "beta" = bayesplay::prior(
      family = "beta",
      alpha  = jaspBase:::.parseRCodeInOptions(priorOptions[["parAlpha"]]),
      beta   = jaspBase:::.parseRCodeInOptions(priorOptions[["parBeta"]])
    ),
    "uniform" = bayesplay::prior(
      family = "uniform",
      min    = jaspBase:::.parseRCodeInOptions(priorOptions[["parA"]]),
      max    = jaspBase:::.parseRCodeInOptions(priorOptions[["parB"]])
    ),
    "spike" = bayesplay::prior(
      family = "point",
      point  = jaspBase:::.parseRCodeInOptions(priorOptions[["parLocation"]])
    )
  )

  # the package does not keep consistent prior naming unfortunately :(
  attr(newPrior, "priorType") <- priorOptions[["type"]]

  return(newPrior)
}
.bayesianTestsPriorName       <- function(prior) {

  priorText <- switch(
    attr(prior, "priorType"),
    "normal"  = paste0("Normal(", prior@data$parameters[1, "mean"], ", ", prior@data$parameters[1, "sd"], ")"),
    "t"       = paste0("Student-t(", prior@data$parameters[1, "mean"], ", ", prior@data$parameters[1, "sd"], ", ", prior@data$parameters[1, "df"], ")"),
    "cauchy"  = paste0("Cauchy(", prior@data$parameters[1, "location"], ", ", prior@data$parameters[1, "scale"], ")"),
    "beta"    = paste0("Beta(", prior@data$parameters[1, "alpha"], ", ", prior@data$parameters[1, "beta"], ")"),
    "uniform" = paste0("Uniform(", prior@data$parameters[1, "min"], ", ", prior@data$parameters[1, "max"], ")"),
    "spike"   = paste0("Spike(", prior@data$parameters[1, "point"], ")")
  )

  # add truncation if not default
  if (attr(prior, "priorType") == "beta" && (prior@data$parameters[1, "range"] != 0 || prior@data$parameters[2, "range"] != 1))
    priorText <- paste0(priorText, "[", prior@data$parameters[1, "range"], ",", prior@data$parameters[2, "range"] ,"]")

  if (attr(prior, "priorType") %in% c("normal", "t", "cauchy") && (!is.infinite(prior@data$parameters[1, "range"]) || !is.infinite(prior@data$parameters[2, "range"])))
    priorText <- paste0(priorText, "[", prior@data$parameters[1, "range"], ",", prior@data$parameters[2, "range"] ,"]")


  return(priorText)
}
.bayesianTestsBf              <- function(null, alt, likelihood) {

  m1 <- likelihood * alt
  m0 <- likelihood * null

  # take the integral of each weighted likelihood
  # and divide them
  bf <- bayesplay::integral(m1) / bayesplay::integral(m0)

  return(bf)
}
.bayesianTestsSummaryTable    <- function(jaspResults, options) {

  if (!is.null(jaspResults[["summaryTable"]]))
    return()

  bfTitle <- .getBayesfactorTitleSummaryStats(options[["bayesFactorType"]], "twoSided")

  summaryTable <- createJaspTable(title = gettext("Model Summary"))
  summaryTable$dependOn(c(.bayesianTestsDependenciesPriors, .bayesianTestsDependenciesData, "bayesFactorType"))
  summaryTable$position <- 1
  summaryTable$addColumnInfo(name = "prior",     title = gettext("Prior"), type = "string")
  summaryTable$addColumnInfo(name = "bf",        title = bfTitle,          type = "number")
  jaspResults[["summaryTable"]] <- summaryTable

  priors     <- jaspResults[["priors"]][["object"]]
  likelihood <- jaspResults[["likelihood"]][["object"]]

  if (is.null(priors[["null"]]) && is.null(likelihood))
    return()

  summaryTable$addFootnote(gettextf(
    "Compared to %1$s.",
    .bayesianTestsPriorName(priors[["null"]])
  ))

  if (is.null(priors[["alt"]]))
    return()

  for (i in seq_along(priors[["alt"]])) {

    # change the BF
    tempBf <- .bayesianTestsBf(priors[["null"]], priors[["alt"]][[i]], likelihood)
    tempBf <- switch(
      options[["bayesFactorType"]],
      "BF10"    = tempBf,
      "BF01"    = 1/tempBf,
      "LogBF10" = log(tempBf)
    )

    summaryTable$addRows(list(
      prior = .bayesianTestsPriorName(priors[["alt"]][[i]]),
      bf    = tempBf
    ))
  }

  return()
}
.bayesianTestsLikelihoodPlot  <- function(jaspResults, options) {

  if (!is.null(jaspResults[["likelihoodPlot"]]))
    return()

  likelihoodPlot <- createJaspPlot(title = "Likelihood", width = 450, height = 300)
  likelihoodPlot$position <- 4
  likelihoodPlot$dependOn(c(.bayesianTestsDependenciesData, "plotLikelihood"))
  jaspResults[["likelihoodPlot"]] <- likelihoodPlot

  likelihood <- jaspResults[["likelihood"]][["object"]]

  if (is.null(likelihood))
    return()

  likelihoodPlotObject <- plot(likelihood)
  likelihoodPlotObject <- jaspGraphs::themeJasp(likelihoodPlotObject)
  likelihoodPlotObject <- .bayesianTestsFixPlotAxis(likelihoodPlotObject, options[["likelihood"]])
  likelihoodPlotObject <- .bayesianTestsFixPlotLabels(likelihoodPlotObject, "likelihood")

  likelihoodPlot[["plotObject"]] <- likelihoodPlotObject

  return()
}
.bayesianTestsPriorsPlot      <- function(jaspResults, options) {

  if (!is.null(jaspResults[["priorsPlot"]]))
    return()

  priorsPlot <- createJaspContainer(title = "Priors")
  priorsPlot$position <- 2
  priorsPlot$dependOn(c(.bayesianTestsDependenciesData, .bayesianTestsDependenciesPriors, "plotPriors"))
  jaspResults[["priorsPlot"]] <- priorsPlot


  priors     <- jaspResults[["priors"]][["object"]]
  likelihood <- jaspResults[["likelihood"]][["object"]]


  ### plot null ---
  priorNullPlot <- createJaspPlot(title = "Null hypothesis", width = 450, height = 300)
  priorsPlot[["priorNullPlot"]] <- priorNullPlot

  if (is.null(priors[["null"]]))
    return()

  priorNullPlotObject <- plot(priors[["null"]])
  priorNullPlotObject <- jaspGraphs::themeJasp(priorNullPlotObject)
  priorNullPlotObject <- .bayesianTestsFixPlotAxis(priorNullPlotObject, options[["likelihood"]])
  priorNullPlotObject <- .bayesianTestsFixPlotLabels(priorNullPlotObject, "priors")

  priorNullPlot[["plotObject"]] <- priorNullPlotObject


  ### plot alternative ---
  priorsAltPlots <- createJaspContainer(title = "Alternative hypotheses")
  priorsPlot[["priorsAltPlots"]] <- priorsAltPlots
  for (i in seq_along(priors[["alt"]])) {

    tempPriorAltPlot <- createJaspPlot(title = .bayesianTestsPriorName(priors[["alt"]][[i]]), width = 450, height = 300)
    priorsAltPlots[[paste0("priorAltPlot", i)]] <- tempPriorAltPlot

    tempPriorAltPlotObject <- plot(priors[["alt"]][[i]])
    tempPriorAltPlotObject <- jaspGraphs::themeJasp(tempPriorAltPlotObject)
    tempPriorAltPlotObject <- .bayesianTestsFixPlotAxis(tempPriorAltPlotObject, options[["likelihood"]])
    tempPriorAltPlotObject <- .bayesianTestsFixPlotLabels(tempPriorAltPlotObject, "priors")

    tempPriorAltPlot[["plotObject"]] <- tempPriorAltPlotObject
  }

  return()
}
.bayesianTestsPosteriorsPlot  <- function(jaspResults, options) {

  if (!is.null(jaspResults[["posteriorsPlot"]]))
    return()

  posteriorsPlot <- createJaspContainer(title = "Posteriors")
  posteriorsPlot$position <- 5
  posteriorsPlot$dependOn(c(.bayesianTestsDependenciesData, .bayesianTestsDependenciesPriors, "plotPosteriors", "plotPosteriorsPriors"))
  jaspResults[["posteriorsPlot"]] <- posteriorsPlot


  priors     <- jaspResults[["priors"]][["object"]]
  likelihood <- jaspResults[["likelihood"]][["object"]]


  ### plot null ---
  plotWidth     <- if (options[["plotPosteriorsPriors"]] && attr(priors[["null"]], "priorType") != "spike") 570 else 450
  priorNullPlot <- createJaspPlot(title = "Null hypothesis", width = plotWidth, height = 300)
  posteriorsPlot[["priorNullPlot"]] <- priorNullPlot

  if (is.null(priors[["null"]]) || is.null(likelihood))
    return()

  # deal with wrong plots for point hypothesis
  priorNullPlotObject <- .bayesianTestsMakePosteriorsPlot(likelihood, priors[["null"]], options)
  priorNullPlotObject <- jaspGraphs::themeJasp(priorNullPlotObject, legend.position = if (options[["plotPosteriorsPriors"]]) "right")
  priorNullPlotObject <- .bayesianTestsFixPlotAxis(priorNullPlotObject, options[["likelihood"]])
  priorNullPlotObject <- .bayesianTestsFixPlotLabels(priorNullPlotObject, "posteriors")

  priorNullPlot[["plotObject"]] <- priorNullPlotObject


  ### plot alternative ---
  posteriorsAltPlots <- createJaspContainer(title = "Alternative hypotheses")
  posteriorsPlot[["posteriorsAltPlots"]] <- posteriorsAltPlots
  for (i in seq_along(priors[["alt"]])) {

    plotWidth     <- if (options[["plotPosteriorsPriors"]] && attr(priors[["alt"]][[i]], "priorType") != "spike") 570 else 450
    tempPosteriorAltPlot <- createJaspPlot(title = .bayesianTestsPriorName(priors[["alt"]][[i]]), width = plotWidth, height = 300)
    posteriorsAltPlots[[paste0("priorAltPlot", i)]] <- tempPosteriorAltPlot

    tempPosteriorAltPlotObject <- .bayesianTestsMakePosteriorsPlot(likelihood, priors[["alt"]][[i]], options)
    tempPosteriorAltPlotObject <- jaspGraphs::themeJasp(tempPosteriorAltPlotObject, legend.position = if (options[["plotPosteriorsPriors"]]) "right")
    tempPosteriorAltPlotObject <- .bayesianTestsFixPlotAxis(tempPosteriorAltPlotObject, options[["likelihood"]])
    tempPosteriorAltPlotObject <- .bayesianTestsFixPlotLabels(tempPosteriorAltPlotObject, "posteriors")

    tempPosteriorAltPlot[["plotObject"]] <- tempPosteriorAltPlotObject
  }

  return()
}
.bayesianTestsPredictionsPlot <- function(jaspResults, options) {

  if (!is.null(jaspResults[["predictionsPlot"]]))
    return()

  predictionsPlot <- createJaspContainer(title = "Prior predictions")
  predictionsPlot$position <- 3
  predictionsPlot$dependOn(c(.bayesianTestsDependenciesData, .bayesianTestsDependenciesPriors, "plotPredictions", "plotPredictionsRatio"))
  jaspResults[["predictionsPlot"]] <- predictionsPlot


  priors     <- jaspResults[["priors"]][["object"]]
  likelihood <- jaspResults[["likelihood"]][["object"]]


  ### plot null ---
  predictionsNullPlot <- createJaspPlot(title = "Null hypothesis", width = 450, height = 300)
  predictionsPlot[["predictionsNullPlot"]] <- predictionsNullPlot

  if (is.null(priors[["null"]]) || is.null(likelihood))
    return()

  predictionsNullPlotObject <- plot(bayesplay::extract_predictions(priors[["null"]] * likelihood))
  predictionsNullPlotObject <- jaspGraphs::themeJasp(predictionsNullPlotObject)
  predictionsNullPlotObject <- .bayesianTestsFixPlotAxis(predictionsNullPlotObject, options[["likelihood"]])

  predictionsNullPlot[["plotObject"]] <- predictionsNullPlotObject


  ### plot alternative ---
  predictionsAltPlots <- createJaspContainer(title = "Alternative hypotheses")
  predictionsPlot[["predictionsAltPlots"]] <- predictionsAltPlots
  for (i in seq_along(priors[["alt"]])) {

    tempPredictionsAltPlot <- createJaspPlot(title = .bayesianTestsPriorName(priors[["alt"]][[i]]), width = 450, height = 300)
    predictionsAltPlots[[paste0("predictionsAltPlot", i)]] <- tempPredictionsAltPlot

    tempPredictionsAltPlotObject <- plot(bayesplay::extract_predictions(priors[["alt"]][[i]] * likelihood))
    tempPredictionsAltPlotObject <- jaspGraphs::themeJasp(tempPredictionsAltPlotObject)
    tempPredictionsAltPlotObject <- .bayesianTestsFixPlotAxis(tempPredictionsAltPlotObject, options[["likelihood"]])

    tempPredictionsAltPlot[["plotObject"]] <- tempPredictionsAltPlotObject
  }

  return()
}
.bayesianTestsFixPlotAxis     <- function(p, likelihood) {

  if (likelihood == "binomial")
    xTicks <- jaspGraphs::getPrettyAxisBreaks(c(0,1))
  else if (ggplot2::layer_scales(p)$x$range$range[1] == ggplot2::layer_scales(p)$x$range$range[2])
    xTicks <- jaspGraphs::getPrettyAxisBreaks(ggplot2::layer_scales(p)$x$range$range[1] + c(-0.5, 0.5))
  else
    xTicks <- jaspGraphs::getPrettyAxisBreaks(ggplot2::layer_scales(p)$x$range$range)

  yTicks <- jaspGraphs::getPrettyAxisBreaks(ggplot2::layer_scales(p)$y$range$range)

  p <- p +
    ggplot2::scale_y_continuous(breaks = yTicks, limits = range(yTicks)) +
    ggplot2::scale_x_continuous(breaks = xTicks, limits = range(xTicks))

  return(p)
}
.bayesianTestsFixPlotLabels   <- function(p, type) {

  if (type == "likelihood")
    p <- p + ggplot2::xlab(expression(theta))
  else if (type == "priors")
    p <- p + ggplot2::xlab(expression(theta)) + ggplot2::ylab(expression(P(theta)))
  else if (type == "posteriors")
    p <- p + ggplot2::xlab(expression(theta)) + ggplot2::ylab(expression(P(theta~"|"~"Data")))

  return(p)
}
.bayesianTestsMakePosteriorsPlot <- function(likelihood, prior, options) {

  # deal with incorrect posterior plot for point prior distributions
  if (attr(prior, "priorType") == "spike") {
    tempPlot <- plot(prior) + ggplot2::ylab("Density")
  } else if (!options[["plotPosteriorsPriors"]]) {
    tempPlot <- plot(bayesplay::extract_posterior(likelihood * prior))
  } else {
    tempPosterior <- bayesplay::extract_posterior(likelihood * prior)
    # adapted from bayesplay:::plot_pp
    tempPlot <- ggplot2::ggplot() +
      ggplot2::geom_function(
        fun       = Vectorize(tempPosterior$posterior_function),
        mapping   = ggplot2::aes(color = "black"),
        linetype  = 1) +
      ggplot2::geom_function(
        fun       = Vectorize(tempPosterior@prior_obj@func),
        mapping   = ggplot2::aes(color = "grey"),
        linetype  = 2) +
      ggplot2::xlim(tempPosterior@prior_obj@plot$range) +
      ggplot2::scale_colour_manual(
        values = c("black", "grey"),
        labels = c("posterior", "prior"),
        name   = NULL) +
      ggplot2::expand_limits(y = 0)
  }


  return(tempPlot)
}
