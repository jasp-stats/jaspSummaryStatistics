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

SummaryStatsBayesianZTest <- function(jaspResults, dataset = NULL, options, ...) {

  # parse formulas
  options <- .bayesianZTestParseOptions(options)

  # get data
  .bayesianZTestGetData(jaspResults, options)

  # get results
  .bayesianZTestSummaryTable(jaspResults, options)

  if (options[["plotPriorAndPosterior"]])
    .bayesianZTestPriorPosteriorPlot(jaspResults, options)

  if (options[["plotBayesFactorRobustness"]])
    .bayesianZTestRobustnessPlot(jaspResults, options)

  return()
}


.bayesianZTestsDependencies   <- c(
  "dataType", "dataEs", "dataSe", "dataLCi", "dataUCi",
  "hypothesis", "priorMean", "priorSd"
  )
.bayesianZTestParseOptions       <- function(options) {

  options[["dataEs"]]  <- jaspBase:::.parseRCodeInOptions(options[["dataEs"]])
  options[["dataSe"]]  <- jaspBase:::.parseRCodeInOptions(options[["dataSe"]])
  options[["dataLCi"]] <- jaspBase:::.parseRCodeInOptions(options[["dataLCi"]])
  options[["dataUCi"]] <- jaspBase:::.parseRCodeInOptions(options[["dataUCi"]])

  options[["priorMean"]] <- jaspBase:::.parseRCodeInOptions(options[["priorMean"]])
  options[["priorSd"]]   <- jaspBase:::.parseRCodeInOptions(options[["priorSd"]])

  return(options)
}
.bayesianZTestGetData            <- function(jaspResults, options) {

  if (!is.null(jaspResults[["data"]]))
    return()

  data <- createJaspState()
  data$dependOn(.bayesianZTestsDependencies)
  jaspResults[["data"]] <- data

  if(options[["dataType"]] == "esAndSe"){
    data[["object"]] <- list(
      "es" = options[["dataEs"]],
      "se" = options[["dataSe"]]
    )
  }else if(options[["dataType"]] == "esAndCi"){
    data[["object"]] <- list(
      "es" = options[["dataEs"]],
      "se" = (options[["dataUCi"]] - options[["dataLCi"]]) / (2 * stats::qnorm(p = 0.975))
    )
  }else if(options[["dataType"]] == "esAndCiLog"){
    data[["object"]] <- list(
      "es" = log(options[["dataEs"]]),
      "se" = (log(options[["dataUCi"]]) - log(options[["dataLCi"]])) / (2 * stats::qnorm(p = 0.975))
    )
  }

  return()
}
.bayesianZTestSummaryTable       <- function(jaspResults, options) {

  if (!is.null(jaspResults[["summaryTable"]]))
    return()

  bfTitle <- .getBayesfactorTitleSummaryStats(options[["bayesFactorType"]], "twoSided")

  summaryTable <- createJaspTable(title = gettext("Model Summary"))
  summaryTable$dependOn(c(.bayesianZTestsDependencies, "bayesFactorType"))
  summaryTable$position <- 1
  summaryTable$addColumnInfo(name = "es",    title = gettext("Effect size"),      type = "number")
  summaryTable$addColumnInfo(name = "se",    title = gettext("Standard error"),   type = "number")
  summaryTable$addColumnInfo(name = "bf",    title = bfTitle,                     type = "number")
  summaryTable$addColumnInfo(name = "maxbf", title = paste0("max(", bfTitle,")"), type = "number")
  jaspResults[["summaryTable"]] <- summaryTable

  data <- jaspResults[["data"]][["object"]]
  bf10 <- .bayesianZTestsComputeBf10(
    x   = data[["es"]],
    se  = data[["se"]],
    mu  = options[["priorMean"]],
    tau = options[["priorSd"]],
    alternative = switch(
      options[["hypothesis"]],
      "notEqualToTestValue"  = "two.sided",
      "greaterThanTestValue" = "greater",
      "lessThanTestValue"    = "less"
    ))
  maxbf <- 1/exp(-(data[["es"]]/data[["se"]])^2/2)

  bf10 <- switch(
    options[["bayesFactorType"]],
    "BF10"    = bf10,
    "BF01"    = 1/bf10,
    "LogBF10" = log(bf10)
  )
  maxbf <- switch(
    options[["bayesFactorType"]],
    "BF10"    = maxbf,
    "BF01"    = 1/maxbf,
    "LogBF10" = log(maxbf)
  )

  summaryTable$addRows(list(
    es    = data[["es"]],
    se    = data[["se"]],
    bf    = bf10,
    maxbf = maxbf
  ))

  return()
}
.bayesianZTestPriorPosteriorPlot <- function(jaspResults, options) {

  if (!is.null(jaspResults[["priorPosteriorPlot"]]))
    return()

  priorPosteriorPlot <- createJaspPlot(title = gettext("Prior Robustness Plot"), width = 450, height = 300)
  priorPosteriorPlot$position <- 2
  priorPosteriorPlot$dependOn(c(.bayesianZTestsDependencies, c("plotPriorAndPosterior", "plotPriorAndPosteriorAdditionalInfo")))
  jaspResults[["priorPosteriorPlot"]] <- priorPosteriorPlot

  data      <- jaspResults[["data"]][["object"]]
  alt       <- switch(
    options[["hypothesis"]],
    "notEqualToTestValue"  = "two.sided",
    "greaterThanTestValue" = "greater",
    "lessThanTestValue"    = "less"
  )

  BF10 <- .bayesianZTestsComputeBf10(
    x  = data[["es"]], se = data[["se"]],
    mu = options[["priorMean"]], tau = options[["priorSd"]],
    alternative = alt
  )
  plotData <- .bayesianZTestsComputePlot(
    x  = data[["es"]], se = data[["se"]],
    mu = options[["priorMean"]], tau = options[["priorSd"]],
    alternative = alt,
    isLog = options[["dataType"]] == "esAndCiLog"
  )

  plot <- jaspGraphs::PlotPriorAndPosterior(
    dfLines    = plotData[["dfLines"]],
    dfPoints   = plotData[["dfPoints"]],
    BF         = if(options[["plotPriorAndPosteriorAdditionalInfo"]]) {if (options[["bayesFactorType"]] == "BF01") 1/BF10 else BF10},
    bfType     = if(options[["plotPriorAndPosteriorAdditionalInfo"]]) {if (options[["bayesFactorType"]] == "BF01") "BF01" else "BF10"},
    hypothesis = switch(
      options[["hypothesis"]],
      "notEqualToTestValue"  = "equal",
      "greaterThanTestValue" = "greater",
      "lessThanTestValue"    = "smaller"
    ),
    xName      = if (options[["dataType"]] == "esAndCiLog") gettext("exp(Effect size)") else gettext("Effect size")
  )

  priorPosteriorPlot[["plotObject"]] <- plot

  return()
}
.bayesianZTestRobustnessPlot     <- function(jaspResults, options) {

  if (!is.null(jaspResults[["robustnessPlot"]]))
    return()

  robustnessPlot <- createJaspPlot(title = gettext("Bayes Factor Robustness Plot"), width = 550, height = 350)
  robustnessPlot$position <- 3
  robustnessPlot$dependOn(c(.bayesianZTestsDependencies, c("plotBayesFactorRobustness" ,"robustnessPriorMeanMin", "robustnessPriorMeanMax", "robustnessPriorSdMin", "robustnessPriorSdMax", "plotBayesFactorRobustnessContours", "plotBayesFactorRobustnessContoursValues")))
  jaspResults[["robustnessPlot"]] <- robustnessPlot

  # specify contour breaks
  formatBF <- function(BF) ifelse(BF < 1, paste0("1/", round(1/BF, 2)), as.character(round(BF, 2)))
  if (options[["plotBayesFactorRobustnessContours"]]) {
    bfBreaks <- strsplit(options[["plotBayesFactorRobustnessContoursValues"]], ",")[[1]]
    bfBreaks <- sapply(bfBreaks, function(bfBreak) eval(parse(text = bfBreak)))
    if (anyNA(bfBreaks)) {
      robustnessPlot$setError(gettext("Bayes factor contours breaks could not be parsed into numbers."))
      return()
    }
  } else {
    bfBreaks <- c(1/100, 1/30, 1/10, 1/3, 1, 3, 10, 30, 100)
  }
  bfLims   <- range(bfBreaks) * c(0.95, 1.05)
  bfLabs   <- formatBF(bfBreaks)

  # compute BF grid
  data      <- jaspResults[["data"]][["object"]]
  priorM    <- seq(options[["robustnessPriorMeanMin"]], options[["robustnessPriorMeanMax"]], length.out = 100)
  priorSD   <- seq(options[["robustnessPriorSdMin"]],   options[["robustnessPriorSdMax"]],   length.out = 100)
  priorSD   <- priorSD[priorSD > 0.001] # in order to keep contours from sliding into the edges
  priorGrid <- expand.grid(mean = priorM, sd = priorSD)
  alt       <- switch(
    options[["hypothesis"]],
    "notEqualToTestValue"  = "two.sided",
    "greaterThanTestValue" = "greater",
    "lessThanTestValue"    = "less"
  )
  priorGrid$bf <- .bayesianZTestsComputeBf10(x = data[["es"]], se = data[["se"]], mu = priorGrid$mean, tau = priorGrid$sd, alternative = alt)
  priorGrid$bf[priorGrid$bf < bfLims[1]] <- bfLims[1]
  priorGrid$bf[priorGrid$bf > bfLims[2]] <- bfLims[2]

  # get plot
  meanBreaks <- jaspGraphs::getPrettyAxisBreaks(range(priorM))
  sdBreaks   <- jaspGraphs::getPrettyAxisBreaks(range(priorSD))
  contours   <- bfBreaks

  plot <- ggplot2::ggplot(
    data    = priorGrid,
    mapping = ggplot2::aes(x = sd, y = mean)
    ) +
    ggplot2::geom_raster(
      mapping = ggplot2::aes(fill = bf),
      alpha   = 0.8
    ) +
    ggplot2::geom_contour(
      mapping = ggplot2::aes(z = bf),
      breaks  = contours,
      color   = "black", lty = 2, alpha = 0.3
    ) +
    metR::geom_text_contour(
      data    = priorGrid,
      mapping = ggplot2::aes(x = sd, y = mean, z = bf),
      breaks  = round(contours, 2), size = 3,
      skip = 0, parse = FALSE, label.placer = metR::label_placer_fraction(frac = 0.5)
    ) +
    colorspace::scale_fill_continuous_diverging(
      palette = "Blue-Red", trans = "log",
      mid = 0, rev = FALSE, p1 = 0.5, p2 = 1.2, ## <- tweak these values
      breaks = bfBreaks, limits = bfLims,
      labels = bfLabs, name = bquote(BF[10])
    ) +
    ggplot2::guides(fill = ggplot2::guide_colorbar(
      barheight = 0.4,
      barwidth  = 28,
      label.vjust = 0.5,
      label.hjust = 0.5)) +
    ggplot2::scale_y_continuous(
      name   = if (options[["dataType"]] == "esAndCiLog") gettext("exp(Prior mean)") else gettext("Prior mean"),
      limits = range(priorM),
      breaks = meanBreaks,
      labels = if (options[["dataType"]] == "esAndCiLog") round(exp(meanBreaks), 2) else meanBreaks,
      expand = c(0, 0)
    ) +
    ggplot2::scale_x_continuous(
      name   = gettext("Prior standard deviation"),
      limits = if(options[["robustnessPriorSdMin"]] == 0) c(0, max(sdBreaks)) else range(sdBreaks),
      breaks = sdBreaks,
      expand = c(0, 0)
    )

  plot <- plot + jaspGraphs::geom_rangeframe() + jaspGraphs::themeJaspRaw(legend.position = "top") +
    ggplot2::theme(
      legend.text.align = 0.5,
      legend.title      = ggplot2::element_text(margin = ggplot2::margin(0, 10, 0, 0)),
      legend.text       = ggplot2::element_text(size = 11),
      plot.margin       = ggplot2::margin(t = 0, r = 50, b = 0, l = 0)
    )

  robustnessPlot[["plotObject"]] <- plot

  return()
}

.bayesianZTestsComputeBf10_ <- function(x, se, mu, tau, alternative = "two.sided") {

  # deal with potential zero tau issues
  if (tau == 0) {
    return(1/exp(-((x-mu)/se)^2/2))
  }

  bfUncorrect <- stats::dnorm(x = x, mean = mu, sd = sqrt(se^2 + tau^2)) /  stats::dnorm(x = x, mean = 0, sd = se)

  if (alternative == "two.sided") {

    bf <- bfUncorrect

  } else {

    postVar  <- 1/(1/se^2 + 1/tau^2)
    postMean <- (x/se^2 + mu/tau^2)*postVar

    if (alternative == "greater")
      bf <- bfUncorrect*pnorm(q = postMean/sqrt(postVar))/stats::pnorm(q = mu/tau)
    else if (alternative == "less")
      bf <- bfUncorrect*pnorm(q = -postMean/sqrt(postVar))/stats::pnorm(q = -mu/tau)
    else
      bf <- NaN

  }

  return(bf)
}
.bayesianZTestsComputePlot  <- function(x, se, mu, tau, alternative = "two.sided", nPoints = 201, isLog = FALSE) {

  if (alternative == "greater")
    xRange <- c(0, mu + 2.5 * tau)
  else if (alternative == "less")
    xRange <- c(mu - 2.5 * tau, 0)
  else if (alternative == "two.sided")
    xRange <- c(mu - 2.5 * tau, mu + 2.5 * tau)

  xRange     <- range(jaspGraphs::getPrettyAxisBreaks(xRange))
  xRange     <- seq(xRange[1], xRange[2], length.out = nPoints)
  yPrior     <- stats::dnorm(xRange, mean = mu, sd = tau)
  yPosterior <- stats::dnorm(xRange, mean = (mu * se^2 + x * tau^2) / (se^2 + tau^2), sd = sqrt( (se^2 * tau^2) / (se^2 + tau^2) ))

  yPrior0     <- stats::dnorm(0, mean = mu, sd = tau)
  yPosterior0 <- stats::dnorm(0, mean = (mu * se^2 + x * tau^2) / (se^2 + tau^2), sd = sqrt( (se^2 * tau^2) / (se^2 + tau^2) ))

  if (alternative != "two.sided") {
    yPrior     <- yPrior     / stats::pnorm(0, mean = mu, sd = tau, lower.tail = alternative == "less")
    yPosterior <- yPosterior / stats::pnorm(0, mean = (mu * se^2 + x * tau^2) / (se^2 + tau^2), sd = sqrt( (se^2 * tau^2) / (se^2 + tau^2) ), lower.tail = alternative == "less")

    yPrior0     <- yPrior0     / stats::pnorm(0, mean = mu, sd = tau, lower.tail = alternative == "less")
    yPosterior0 <- yPosterior0 / stats::pnorm(0, mean = (mu * se^2 + x * tau^2) / (se^2 + tau^2), sd = sqrt( (se^2 * tau^2) / (se^2 + tau^2) ), lower.tail = alternative == "less")
  }

  if (isLog) {
    # Jacobian adjustment for log scale
    xRange      <- exp(xRange)
    yPrior      <- yPrior      * 1/xRange
    yPosterior  <- yPosterior  * 1/xRange
  }

  dfLines <- data.frame(
    x = c(xRange, xRange),
    y = c(yPrior, yPosterior),
    g = rep(c("Prior", "Posterior"), each = nPoints)
  )

  dfPoints <- data.frame(
    x = if (isLog) c(1, 1) else c(0, 0),
    y = c(yPrior0, yPosterior0),
    g = rep(c("Prior", "Posterior"))
  )

  return(list(
    dfLines  = dfLines,
    dfPoints = dfPoints
  ))
}
.bayesianZTestsComputeBf10  <- Vectorize(FUN = .bayesianZTestsComputeBf10_)
