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
  if (options[["priorPlot"]])
    .bayesianTestsPriorsPlot(jaspResults, options)

  if (options[["predictionPlot"]])
    .bayesianTestsPredictionsPlot(jaspResults, options)

  if (options[["likelihoodPlot"]])
    .bayesianTestsLikelihoodPlot(jaspResults, options)

  if (options[["posteriorPlot"]])
    .bayesianTestsPosteriorsPlot(jaspResults, options)

  return()
}

.bayesianTestsDependenciesPriors <- c("priorsAlt", paste0("null", c("ParA", "ParAlpha", "ParB", "ParBeta", "ParDf", "ParLocation", "ParMean", "ParScale", "ParScale2", "TruncationLower", "TruncationUpper", "Type")))
.bayesianTestsDependenciesData   <- c("likelihood", "dataMean", "dataSd", "dataDf", "dataT", "dataD", "dataObservations", "dataObservationsGroup1", "dataObservationsGroup2", "dataSuccesses")

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
    "nonCentralD2" = bayesplay::likelihood(
      family = "noncentral_d2",
      d      = jaspBase:::.parseRCodeInOptions(options[["dataD"]]),
      n1     = jaspBase:::.parseRCodeInOptions(options[["dataObservationsGroup1"]]),
      n2     = jaspBase:::.parseRCodeInOptions(options[["dataObservationsGroup2"]])
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
    "normal"  = gettextf("Normal(%1$s, %2$s)", prior$parameters[["mean"]], prior$parameters[["sd"]]),
    "t"       = gettextf("Student-t(%1$s, %2$s, %3$s)", prior$parameters[["mean"]], prior$parameters[["sd"]], prior$parameters[["df"]]),
    "cauchy"  = gettextf("Cauchy(%1$s, %2$s)", prior$parameters[["location"]], prior$parameters[["scale"]]),
    "beta"    = gettextf("Beta(%1$s, %2$s)", prior$parameters[["alpha"]], prior$parameters[["beta"]]),
    "uniform" = gettextf("Uniform(%1$s, %2$s)", prior$parameters[["min"]], prior$parameters[["max"]]),
    "spike"   = gettextf("Spike(%1$s)", prior$parameters[["point"]])
  )

  # add truncation if not default
  if (attr(prior, "priorType") == "beta" && (prior$parameters[["range"]][1] != 0 || prior$parameters[["range"]][2] != 1))
    priorText <- paste0(priorText, "[", prior$parameters[["range"]][1], ",", prior$parameters[["range"]][2] ,"]")

  if (attr(prior, "priorType") %in% c("normal", "t", "cauchy") && (!is.infinite(prior$parameters[["range"]][1]) || !is.infinite(prior$parameters[["range"]][2])))
    priorText <- paste0(priorText, "[", prior$parameters[["range"]][1], ",", prior$parameters[["range"]][2] ,"]")


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

  if (options[["likelihood"]] == "normal")
    summaryTable$addFootnote(gettext("The variance parameter of the normal distribution is assumed to be known."))

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
  likelihoodPlot$dependOn(c(.bayesianTestsDependenciesData, "likelihoodPlot"))
  jaspResults[["likelihoodPlot"]] <- likelihoodPlot

  likelihood <- jaspResults[["likelihood"]][["object"]]

  if (is.null(likelihood))
    return()

  likelihoodPlotObject <- .bayesianTestsMakeLikelihoodPlot(likelihood)
  likelihoodPlotObject <- likelihoodPlotObject + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw()
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
  priorsPlot$dependOn(c(.bayesianTestsDependenciesData, .bayesianTestsDependenciesPriors, "priorPlot"))
  jaspResults[["priorsPlot"]] <- priorsPlot


  priors     <- jaspResults[["priors"]][["object"]]
  likelihood <- jaspResults[["likelihood"]][["object"]]


  ### plot null ---
  priorNullPlot <- createJaspPlot(title = "Null hypothesis", width = 450, height = 300)
  priorsPlot[["priorNullPlot"]] <- priorNullPlot

  if (is.null(priors[["null"]]))
    return()

  priorNullPlotObject <- .bayesianTestsMakePriorPlot(priors[["null"]])
  priorNullPlotObject <- priorNullPlotObject + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw()
  priorNullPlotObject <- .bayesianTestsFixPlotAxis(priorNullPlotObject, options[["likelihood"]])
  priorNullPlotObject <- .bayesianTestsFixPlotLabels(priorNullPlotObject, "priors")

  priorNullPlot[["plotObject"]] <- priorNullPlotObject


  ### plot alternative ---
  priorsAltPlots <- createJaspContainer(title = "Alternative hypotheses")
  priorsPlot[["priorsAltPlots"]] <- priorsAltPlots
  for (i in seq_along(priors[["alt"]])) {

    tempPriorAltPlot <- createJaspPlot(title = .bayesianTestsPriorName(priors[["alt"]][[i]]), width = 450, height = 300)
    priorsAltPlots[[paste0("priorAltPlot", i)]] <- tempPriorAltPlot

    tempPriorAltPlotObject <- .bayesianTestsMakePriorPlot(priors[["alt"]][[i]])
    tempPriorAltPlotObject <- tempPriorAltPlotObject + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw()
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
  posteriorsPlot$dependOn(c(.bayesianTestsDependenciesData, .bayesianTestsDependenciesPriors, "posteriorPlot", "posteriorPlotPrior"))
  jaspResults[["posteriorsPlot"]] <- posteriorsPlot


  priors     <- jaspResults[["priors"]][["object"]]
  likelihood <- jaspResults[["likelihood"]][["object"]]


  ### plot null ---
  plotWidth     <- if (options[["posteriorPlotPrior"]] && attr(priors[["null"]], "priorType") != "spike") 570 else 450
  priorNullPlot <- createJaspPlot(title = "Null hypothesis", width = plotWidth, height = 300)
  posteriorsPlot[["priorNullPlot"]] <- priorNullPlot

  if (is.null(priors[["null"]]) || is.null(likelihood))
    return()

  # deal with wrong plots for point hypothesis
  priorNullPlotObject <- .bayesianTestsMakePosteriorsPlot(likelihood, priors[["null"]], options)
  priorNullPlotObject <- priorNullPlotObject + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw(legend.position = if (options[["posteriorPlotPrior"]]) "right")
  priorNullPlotObject <- .bayesianTestsFixPlotAxis(priorNullPlotObject, options[["likelihood"]])
  priorNullPlotObject <- .bayesianTestsFixPlotLabels(priorNullPlotObject, "posteriors")

  priorNullPlot[["plotObject"]] <- priorNullPlotObject


  ### plot alternative ---
  posteriorsAltPlots <- createJaspContainer(title = "Alternative hypotheses")
  posteriorsPlot[["posteriorsAltPlots"]] <- posteriorsAltPlots
  for (i in seq_along(priors[["alt"]])) {

    plotWidth     <- if (options[["posteriorPlotPrior"]] && attr(priors[["alt"]][[i]], "priorType") != "spike") 570 else 450
    tempPosteriorAltPlot <- createJaspPlot(title = .bayesianTestsPriorName(priors[["alt"]][[i]]), width = plotWidth, height = 300)
    posteriorsAltPlots[[paste0("priorAltPlot", i)]] <- tempPosteriorAltPlot

    tempPosteriorAltPlotObject <- .bayesianTestsMakePosteriorsPlot(likelihood, priors[["alt"]][[i]], options)
    tempPosteriorAltPlotObject <- tempPosteriorAltPlotObject + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw(legend.position = if (options[["posteriorPlotPrior"]]) "right")
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
  predictionsPlot$dependOn(c(.bayesianTestsDependenciesData, .bayesianTestsDependenciesPriors, "predictionPlot", "predictionPlotRatio"))
  jaspResults[["predictionsPlot"]] <- predictionsPlot


  priors     <- jaspResults[["priors"]][["object"]]
  likelihood <- jaspResults[["likelihood"]][["object"]]


  ### plot null ---
  predictionsNullPlot <- createJaspPlot(title = "Null hypothesis", width = 450, height = 300)
  predictionsPlot[["predictionsNullPlot"]] <- predictionsNullPlot

  if (is.null(priors[["null"]]) || is.null(likelihood))
    return()

  predictionsNullPlotObject <- .bayesianTestsMakePredictionPlot(likelihood, priors[["null"]])
  predictionsNullPlotObject <- predictionsNullPlotObject + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw()
  predictionsNullPlotObject <- .bayesianTestsFixPlotAxis(predictionsNullPlotObject, options[["likelihood"]], predictions = TRUE)

  predictionsNullPlot[["plotObject"]] <- predictionsNullPlotObject


  ### plot alternative ---
  predictionsAltPlots <- createJaspContainer(title = "Alternative hypotheses")
  predictionsPlot[["predictionsAltPlots"]] <- predictionsAltPlots
  for (i in seq_along(priors[["alt"]])) {

    tempPredictionsAltPlot <- createJaspPlot(title = .bayesianTestsPriorName(priors[["alt"]][[i]]), width = 450, height = 300)
    predictionsAltPlots[[paste0("predictionsAltPlot", i)]] <- tempPredictionsAltPlot

    tempPredictionsAltPlotObject <- .bayesianTestsMakePredictionPlot(likelihood, priors[["alt"]][[i]])
    tempPredictionsAltPlotObject <- tempPredictionsAltPlotObject + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw()
    tempPredictionsAltPlotObject <- .bayesianTestsFixPlotAxis(tempPredictionsAltPlotObject, options[["likelihood"]], predictions = TRUE)

    tempPredictionsAltPlot[["plotObject"]] <- tempPredictionsAltPlotObject
  }

  return()
}
.bayesianTestsFixPlotAxis     <- function(p, likelihood, predictions = FALSE) {

  if (likelihood == "binomial" && !predictions)
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
.bayesianTestsMakePriorPlot      <- function(prior) {

  # adapted from bayesplay:::plot.prior
  if (prior$family == "point")
    tempPlot <- ggplot2::ggplot() +
      ggplot2::geom_point(
        mapping = ggplot2::aes(
          x    = prior$parameters[["point"]],
          y    = 1
        ),
        size  = 4,
        shape = 16) +
      ggplot2::geom_linerange(
        mapping = ggplot2::aes(
          x    = prior$parameters[["point"]],
          y    = NULL,
          ymin = 0,
          ymax = 1),
        size = 1) +
      ggplot2::xlim(prior@plot$range) +
      ggplot2::expand_limits(y = 0) +
      ggplot2::ylab(gettext(gettext("Probability")))
  else
    tempPlot <- ggplot2::ggplot() +
      ggplot2::geom_function(
        fun       = Vectorize(prior@func),
        color     = "black",
        size      = 1,
        linetype  = 1) +
      ggplot2::xlim(prior@plot$range) +
      ggplot2::expand_limits(y = 0) +
      ggplot2::ylab(gettext(gettext("Density")))

  return(tempPlot)
}
.bayesianTestsMakeLikelihoodPlot <- function(likelihood) {

  tempPlot <- .bayesianTestsMakePriorPlot(likelihood) +
    ggplot2::ylab("P(Outcome)")

  return(tempPlot)
}
.bayesianTestsMakePredictionPlot <- function(likelihood, prior) {

  x <- bayesplay::extract_predictions(prior * likelihood)

  # based on: bayesplay:::handle_binomial_marginal and bayesplay:::handle_other_marginal
  n          <- 101
  model_name <- "model"

  likelihood_obj    <- x@likelihood_obj
  likelihood_family <- likelihood_obj$family

  if (likelihood_family == "binomial") {

    model_func     <- x$prediction_function
    plot_range     <- c(0, bayesplay:::get_binomial_trials(x))
    observation    <- x@likelihood_obj@observation
    observation_df <- data.frame(
      observation = observation,
      auc         = model_func(observation),
      color       = model_name,
      linetype    = model_name
    )
    observation_range <- seq(plot_range[1], plot_range[2], 1)
    counterfactual    <- data.frame(
      observation = observation_range,
      auc = unlist(lapply(observation_range, FUN = model_func))
    )

    tempPlot <- ggplot2::ggplot() +
      ggplot2::geom_line(
        data    = counterfactual,
        mapping = ggplot2::aes(
          x      = observation,
          y      = auc,
          colour = model_name),
        size    = 1) +
      ggplot2::geom_point(
        data    = counterfactual,
        mapping = ggplot2::aes(
          x      = observation,
          y      = auc,
          colour = model_name),
        size   = 4,
        shape  = 21,
        stroke = 1.25,
        fill   = "grey") +
      ggplot2::geom_point(
        data    = observation_df,
        mapping = ggplot2::aes(
          x      = observation,
          y      = auc,
          colour = model_name),
        size   = 4,
        shape  = 21,
        stroke = 1.25,
        fill   = "grey") +
      ggplot2::labs(x = "Outcome", y = "Marginal probability") +
      ggplot2::scale_color_manual(values = "black",name = NULL, labels = NULL, guide = "none") +
      ggplot2::scale_linetype_manual(values = 1, name = NULL, labels = NULL, guide = "none") +
      ggplot2::scale_x_continuous(limits = plot_range, breaks = bayesplay:::integer_breaks())

  }else{

    model_func     <- x$prediction_function
    plot_range     <- bayesplay:::get_max_range(x)
    observation    <- x@likelihood_obj@observation
    x              <- observation
    y              <- model_func(observation)
    color          <- model_name
    linetype       <- model_name
    observation_df <- data.frame(
      x        = x,
      y        = y,
      color    = color,
      linetype = linetype)

    tempPlot <- ggplot2::ggplot() +
      ggplot2::geom_function(
        fun = model_func,
        mapping    = ggplot2::aes(
          colour   = model_name,
          linetype = model_name),
        size = 1) +
      ggplot2::geom_point(
        data    = observation_df,
        mapping = ggplot2::aes(
          x      = x,
          y      = y,
          colour = model_name),
        size   = 4,
        shape  = 21,
        stroke = 1.25,
        fill   = "grey") +
      ggplot2::labs(x = "Outcome", y = "Marginal probability") +
      ggplot2::scale_color_manual(values = "black", name = NULL, labels = NULL, guide = "none") +
      ggplot2::scale_linetype_manual(values = 1,name = NULL, labels = NULL, guide = "none") +
      ggplot2::scale_x_continuous(limits = plot_range)
  }

  return(tempPlot)
}
.bayesianTestsMakePosteriorsPlot <- function(likelihood, prior, options) {

  tempPosterior <- bayesplay::extract_posterior(likelihood * prior)

  # adapted from bayesplay:::plot_pp
  if (prior$family == "point")
    tempPlot <- ggplot2::ggplot() +
      ggplot2::geom_point(
        mapping = ggplot2::aes(
          x    = prior$parameters[["point"]],
          y    = 1),
        size  = 4,
        shape = 16) +
      ggplot2::geom_linerange(
        mapping = ggplot2::aes(
          x    = prior$parameters[["point"]],
          y    = NULL,
          ymin = 0,
          ymax = 1),
        size = 1) +
      ggplot2::xlim(tempPosterior@prior_obj@plot$range) +
      ggplot2::expand_limits(y = 0) +
      ggplot2::ylab(gettext(gettext("Probability")))
  else if (!options[["posteriorPlotPrior"]])
    tempPlot <- ggplot2::ggplot() +
      ggplot2::geom_function(
        fun       = Vectorize(tempPosterior$posterior_function),
        color     = "black",
        size      = 1,
        linetype  = 1) +
      ggplot2::xlim(tempPosterior@prior_obj@plot$range) +
      ggplot2::expand_limits(y = 0) +
      ggplot2::ylab(gettext(gettext("Density")))
  else
    tempPlot <- ggplot2::ggplot() +
      ggplot2::geom_function(
        fun       = Vectorize(tempPosterior$posterior_function),
        mapping   = ggplot2::aes(color = "black"),
        size      = 1,
        linetype  = 1) +
      ggplot2::geom_function(
        fun       = Vectorize(tempPosterior@prior_obj@func),
        mapping   = ggplot2::aes(color = "grey"),
        size      = 1,
        linetype  = 2) +
      ggplot2::scale_colour_manual(
        values = c("black", "grey"),
        labels = c("Posterior", "Prior"),
        guide  = ggplot2::guide_legend(override.aes = list(
          linetype = c(1,  2)
        )),
        name   = NULL) +
      ggplot2::xlim(tempPosterior@prior_obj@plot$range) +
      ggplot2::expand_limits(y = 0) +
      ggplot2::ylab(gettext(gettext("Density")))

  return(tempPlot)
}
