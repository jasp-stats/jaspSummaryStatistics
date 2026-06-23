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

# Process input type options for equivalence t-test, extending the standard
# .processInputTypeOptions to also extract SD for raw scale conversion
.processInputTypeOptionsEquivalence <- function(options, analysis = "independentSamples") {

  # First, extract SD information when available (before converting to t)
  if (analysis == "independentSamples") {
    if (options[["inputType"]] == "meansAndSDs" && options[["sd1"]] > 0 && options[["sd2"]] > 0 &&
        options[["sampleSizeGroupOne"]] > 0 && options[["sampleSizeGroupTwo"]] > 0) {
      options[[".pooledSd"]] <- sqrt(
        ((options[["sd1"]] ^ 2) * (options[["sampleSizeGroupOne"]] - 1) +
         (options[["sd2"]] ^ 2) * (options[["sampleSizeGroupTwo"]] - 1)) /
        (options[["sampleSizeGroupOne"]] + options[["sampleSizeGroupTwo"]] - 2)
      )
    }
  } else if (analysis == "pairedSamples") {
    if (options[["inputType"]] == "meanDiffAndSD" && options[["sdDifference"]] > 0) {
      options[[".sampleSd"]] <- options[["sdDifference"]]
    }
  } else if (analysis == "oneSample") {
    if (options[["inputType"]] == "meanAndSD" && options[["sd"]] > 0) {
      options[[".sampleSd"]] <- options[["sd"]]
    }
  }

  # Now use the standard conversion to get the t-statistic
  options <- .processInputTypeOptions(options, analysis)

  return(options)
}

# Get the SD for raw scale conversion (returns NULL if not available)
.getEquivalenceSd <- function(options, analysis) {
  if (analysis == "independentSamples") {
    return(options[[".pooledSd"]])
  } else {
    return(options[[".sampleSd"]])
  }
}

# Compute the equivalence BF from summary statistics
.generalSummaryEquivalenceTtestBF <- function(options, analysis) {

  tValue <- options[["tStatistic"]]
  n1 <- options[["sampleSizeGroupOne"]]
  n2 <- if (analysis == "independentSamples") options[["sampleSizeGroupTwo"]] else 0

  independentSamples <- (analysis == "independentSamples")

  if (options[["effectSizeStandardized"]] == "default") {

    bfObject <- jaspEquivalenceTTests:::.equivalence_bf_t(
      t                  = tValue,
      n1                 = n1,
      n2                 = n2,
      independentSamples = independentSamples,
      prior.location     = 0,
      prior.scale        = options[["priorWidth"]],
      prior.df           = 1,
      options            = options
    )

  } else if (options[["informativeStandardizedEffectSize"]] == "cauchy") {

    bfObject <- jaspEquivalenceTTests:::.equivalence_bf_t(
      t                  = tValue,
      n1                 = n1,
      n2                 = n2,
      independentSamples = independentSamples,
      prior.location     = options[["informativeCauchyLocation"]],
      prior.scale        = options[["informativeCauchyScale"]],
      prior.df           = 1,
      options            = options
    )

  } else if (options[["informativeStandardizedEffectSize"]] == "t") {

    bfObject <- jaspEquivalenceTTests:::.equivalence_bf_t(
      t                  = tValue,
      n1                 = n1,
      n2                 = n2,
      independentSamples = independentSamples,
      prior.location     = options[["informativeTLocation"]],
      prior.scale        = options[["informativeTScale"]],
      prior.df           = options[["informativeTDf"]],
      options            = options
    )

  } else if (options[["informativeStandardizedEffectSize"]] == "normal") {

    bfObject <- jaspEquivalenceTTests:::.equivalence_bf_normal(
      t                  = tValue,
      n1                 = n1,
      n2                 = n2,
      independentSamples = independentSamples,
      prior.mean         = options[["informativeNormalMean"]],
      prior.variance     = options[["informativeNormalStd"]]^2,
      options            = options
    )

  }

  return(list(
    bfEquivalence                   = bfObject$bfEquivalence,
    bfNonequivalence                = bfObject$bfNonequivalence,
    errorPrior                      = bfObject$errorPrior,
    errorPosterior                  = bfObject$errorPosterior,
    tValue                          = tValue,
    n1                              = n1,
    n2                              = n2,
    integralEquivalencePrior        = bfObject$integralEquivalencePrior,
    integralEquivalencePosterior    = bfObject$integralEquivalencePosterior,
    integralNonequivalencePrior     = bfObject$integralNonequivalencePrior,
    integralNonequivalencePosterior = bfObject$integralNonequivalencePosterior
  ))
}

# Main function: orchestrates computation, table creation, and filling
.summaryStatsEquivalenceTTestMainFunction <- function(jaspResults, options, analysis) {

  container <- jaspResults[["equivalenceContainer"]]
  if (is.null(container)) {
    container <- createJaspContainer()
    container$dependOn(c(
      "tStatistic", "sampleSizeGroupOne", "sampleSizeGroupTwo", "sampleSize",
      "mean", "sd", "meanDifference", "sdDifference", "mean1", "mean2", "sd1", "sd2",
      "cohensD", "inputType", "testValue",
      "alternative", "bayesFactorType",
      "effectSizeStandardized", "defaultStandardizedEffectSize",
      "priorWidth",
      "informativeStandardizedEffectSize",
      "informativeCauchyLocation", "informativeCauchyScale",
      "informativeNormalMean", "informativeNormalStd",
      "informativeTLocation", "informativeTScale", "informativeTDf",
      "rawEffectSize",
      "rawCauchyLocation", "rawCauchyScale",
      "rawNormalMean", "rawNormalStd",
      "rawTLocation", "rawTScale", "rawTDf",
      "equivalenceRegion",
      "lowerbound", "upperbound",
      "lower_max", "upper_min",
      "upperbound_greater", "lowerbound_less",
      "boundstype"
    ))
    jaspResults[["equivalenceContainer"]] <- container
  }

  # If table already exists, return cached results
  if (!is.null(container[["equivalenceTable"]]))
    return(container[["stateEquivalenceResults"]]$object)

  # Create and add the table
  container[["equivalenceTable"]] <- .summaryStatsEquivalenceTTestTableMain(options, analysis)

  if (!is.null(container[["stateEquivalenceResults"]])) {
    results <- container[["stateEquivalenceResults"]]$object
  } else {
    results <- .summaryStatsEquivalenceTTestComputeResults(options, analysis)
    container[["stateEquivalenceResults"]] <- createJaspState(results)

    if (!is.null(results[["errorMessageTable"]]))
      container[["equivalenceTable"]]$setError(results[["errorMessageTable"]])
  }

  # Fill table if ready
  if (results[["ready"]])
    .summaryStatsEquivalenceTTestFillTable(container[["equivalenceTable"]], options, results)

  return(results)
}

# Add footnote about the equivalence interval scale
.addEquivalenceSummaryStatsFootnote <- function(table, options) {

  formatBound <- function(x) {
    if (is.infinite(x) && x < 0) return("-\u221E")
    if (is.infinite(x) && x > 0) return("\u221E")
    return(format(x, digits = 3))
  }

  if (options[["boundstype"]] == "cohensD") {
    message <- gettextf(
      "I ranges from %1$s to %2$s on the Cohen's d scale.",
      formatBound(options[["lowerbound"]]),
      formatBound(options[["upperbound"]])
    )
    table$addFootnote(message)
  } else if (options[["boundstype"]] == "raw") {
    # After conversion, options$lowerbound/upperbound are in SMD scale
    # .rawLowerbound/.rawUpperbound hold the original raw values
    rawLower <- options[[".rawLowerbound"]]
    rawUpper <- options[[".rawUpperbound"]]
    if (!is.null(rawLower) && !is.null(rawUpper)) {
      message <- gettextf(
        "I ranges from %1$s to %2$s on the raw scale (corresponding to [%3$s, %4$s] on the Cohen's d scale).",
        formatBound(rawLower),
        formatBound(rawUpper),
        formatBound(options[["lowerbound"]]),
        formatBound(options[["upperbound"]])
      )
      table$addFootnote(message)
    }
  }

  return()
}

# Create the empty equivalence BF table
.summaryStatsEquivalenceTTestTableMain <- function(options, analysis) {

  tableTitle <- switch(analysis,
    "independentSamples" = gettext("Bayesian Equivalence Independent Samples T-Test"),
    "oneSample"          = gettext("Bayesian Equivalence One Sample T-Test"),
    "pairedSamples"      = gettext("Bayesian Equivalence Paired Samples T-Test")
  )

  table <- createJaspTable(title = tableTitle)
  table$dependOn("bayesFactorType")
  table$position <- 1
  table$showSpecifiedColumnsOnly <- TRUE

  hypothesis <- switch(options[["alternative"]],
    "twoSided" = "equal",
    "greater"  = "greater",
    "less"     = "smaller"
  )
  bfTitle <- jaspTTests:::.ttestBayesianGetBFTitle(
    bfType     = options[["bayesFactorType"]],
    hypothesis = hypothesis
  )

  # Columns
  table$addColumnInfo(name = "type",      title = gettext("Type"),              type = "string")
  table$addColumnInfo(name = "statistic", title = gettext("Model Comparison"),  type = "string")
  table$addColumnInfo(name = "bf",        title = bfTitle,                      type = "number")
  table$addColumnInfo(name = "error",     title = gettextf("error %%"),         type = "number")

  # Citations
  if (options[["effectSizeStandardized"]] == "default") {
    table$addCitation(.summaryStatsCitations[c("MoreyRounder2015", "RounderEtAl2009")])
  } else if (options[["effectSizeStandardized"]] == "informative") {
    table$addCitation(.summaryStatsCitations[c("GronauEtAl2017")])
  }

  # Add scale-specific footnote for equivalence interval
  .addEquivalenceSummaryStatsFootnote(table, options)

  return(table)
}

# Compute the equivalence BF results
.summaryStatsEquivalenceTTestComputeResults <- function(options, analysis) {

  t  <- options[["tStatistic"]]
  n1 <- options[["sampleSizeGroupOne"]]

  if (analysis == "independentSamples") {
    n2    <- options[["sampleSizeGroupTwo"]]
    ready <- !(n1 == 0 || n2 == 0)
  } else {
    n2    <- 0
    ready <- !(n1 == 0)
  }

  if (!ready)
    return(list(ready = ready))

  r <- try(.generalSummaryEquivalenceTtestBF(options = options, analysis = analysis))

  if (isTryError(r)) {
    return(list(
      ready             = ready,
      errorMessageTable = .extractErrorMessage(r)
    ))
  }

  if (r[["bfEquivalence"]] < 0 || r[["bfNonequivalence"]] < 0) {
    return(list(
      ready             = ready,
      errorMessageTable = gettext("Not able to calculate Bayes factor while the integration was too unstable.")
    ))
  }

  results <- list(
    ready                           = ready,
    t                               = t,
    n1                              = n1,
    n2                              = n2,
    bfEquivalence                   = r$bfEquivalence,
    bfNonequivalence                = r$bfNonequivalence,
    errorPrior                      = r$errorPrior,
    errorPosterior                  = r$errorPosterior,
    integralEquivalencePrior        = r$integralEquivalencePrior,
    integralEquivalencePosterior    = r$integralEquivalencePosterior,
    integralNonequivalencePrior     = r$integralNonequivalencePrior,
    integralNonequivalencePosterior = r$integralNonequivalencePosterior
  )

  return(results)
}

# Fill the 3-row equivalence table
.summaryStatsEquivalenceTTestFillTable <- function(table, options, results) {

  bfType <- options[["bayesFactorType"]]

  # Row 1: Overlapping (inside vs all)
  error_in_alt  <- (results$errorPrior + results$errorPosterior) / results$bfEquivalence
  bfEquivalence <- .recodeBFtype(
    bfOld     = results$bfEquivalence,
    newBFtype = bfType,
    oldBFtype = "BF10"
  )

  row1 <- list(
    type      = gettextf("Overlapping (%1$s vs. %2$s)",
                  if (bfType %in% c("BF10", "LogBF10")) gettext("inside") else gettext("all"),
                  if (bfType %in% c("BF10", "LogBF10")) gettext("all")    else gettext("inside")),
    statistic = "\U003B4 \U02208 I vs. H\u2081",
    bf        = bfEquivalence,
    error     = ifelse(error_in_alt == Inf, "NA", error_in_alt)
  )

  table$addRows(row1)

  # Row 2: Overlapping (outside vs all)
  error_notin_alt  <- (results$errorPrior + results$errorPosterior) / results$bfNonequivalence
  bfNonequivalence <- .recodeBFtype(
    bfOld     = results$bfNonequivalence,
    newBFtype = bfType,
    oldBFtype = "BF10"
  )

  row2 <- list(
    type      = gettextf("Overlapping (%1$s vs. %2$s)",
                  if (bfType %in% c("BF10", "LogBF10")) gettext("outside") else gettext("all"),
                  if (bfType %in% c("BF10", "LogBF10")) gettext("all")     else gettext("outside")),
    statistic = "\U003B4 \U02209 I vs. H\u2081",
    bf        = bfNonequivalence,
    error     = ifelse(error_notin_alt == Inf, "NA", error_notin_alt)
  )

  table$addRows(row2)

  # Row 3: Non-overlapping (inside vs outside)
  error_in_notin <- (2 * (results$errorPrior + results$errorPosterior)) / (results$bfEquivalence / results$bfNonequivalence)
  bfNonoverlapping <- .recodeBFtype(
    bfOld     = results$bfEquivalence / results$bfNonequivalence,
    newBFtype = bfType,
    oldBFtype = "BF10"
  )

  row3 <- list(
    type      = gettextf("Non-overlapping (%1$s vs. %2$s)",
                  if (bfType %in% c("BF10", "LogBF10")) gettext("inside")  else gettext("outside"),
                  if (bfType %in% c("BF10", "LogBF10")) gettext("outside") else gettext("inside")),
    statistic = "\U003B4 \U02208 I vs. \U003B4 \U02209 I",
    bf        = bfNonoverlapping,
    error     = ifelse(error_in_notin == Inf, "NA", error_in_notin)
  )

  table$addRows(row3)

  # Add footnote with computed t statistic when input is not directly t
  if (options[["inputType"]] != "tAndN") {
    table$addFootnote(gettextf("The input corresponds to a t-statistic = %s.", format(results$t, digits = 3)))
  }

  return()
}

# Prior and Posterior plot for equivalence summary statistics
.summaryStatsEquivalencePriorPosteriorPlot <- function(jaspResults, results, options, analysis) {

  if (!options[["priorandposterior"]] || !is.null(jaspResults[["equivalenceContainer"]][["priorPosteriorPlot"]]))
    return()

  plot <- createJaspPlot(
    title       = gettext("Prior and Posterior"),
    width       = 480,
    height      = 320,
    aspectRatio = 0.7
  )
  plot$position <- 2
  plot$dependOn(options = c("priorandposterior", "priorandposteriorAdditionalInfo"))
  jaspResults[["equivalenceContainer"]][["priorPosteriorPlot"]] <- plot

  if (!results[["ready"]] || jaspResults[["equivalenceContainer"]]$getError())
    return()

  t      <- results[["t"]]
  n1     <- results[["n1"]]
  n2     <- results[["n2"]]
  paired <- (analysis != "independentSamples")

  oneSided <- switch(
    options[["alternative"]],
    "greater" = "right",
    "less"    = "left",
    FALSE
  )

  addInformation <- options[["priorandposteriorAdditionalInfo"]]

  # Use the options passed (which may have been converted from raw to SMD already)
  optionsForPlot <- options

  # Determine the prior density/CDF computation parameters
  BF <- results$bfEquivalence / results$bfNonequivalence
  if (BF == 0 || BF == Inf) {
    plot$setError(gettext("Currently a plot with a Bayes factor of Inf or 0 is not supported."))
    return()
  }

  r <- optionsForPlot[["priorWidth"]]

  xlim <- vector("numeric", 2)

  p <- try({

    if (optionsForPlot[["effectSizeStandardized"]] == "default") {

      ci99PlusMedian <- jaspTTests::.ciPlusMedian_t(
        t                  = t, n1 = n1, n2 = n2,
        independentSamples = !paired && n2 > 0,
        prior.location     = 0,
        prior.scale        = r,
        prior.df           = 1,
        ci                 = .99,
        oneSided           = oneSided
      )

      priorLower <- jaspTTests::.qShiftedT(.15, parameters = c(0, r, 1), oneSided = oneSided)
      priorUpper <- jaspTTests::.qShiftedT(.85, parameters = c(0, r, 1), oneSided = oneSided)

      ci95PlusMedian <- jaspTTests::.ciPlusMedian_t(
        t                  = t, n1 = n1, n2 = n2,
        independentSamples = !paired && n2 > 0,
        prior.location     = 0,
        prior.scale        = r,
        prior.df           = 1,
        ci                 = .95,
        oneSided           = oneSided
      )

    } else if (optionsForPlot[["informativeStandardizedEffectSize"]] == "cauchy") {

      ci99PlusMedian <- jaspTTests::.ciPlusMedian_t(
        t                  = t, n1 = n1, n2 = n2,
        independentSamples = !paired && n2 > 0,
        prior.location     = optionsForPlot[["informativeCauchyLocation"]],
        prior.scale        = optionsForPlot[["informativeCauchyScale"]],
        prior.df           = 1,
        ci                 = .99,
        oneSided           = oneSided
      )

      priorLower <- jaspTTests::.qShiftedT(.15, parameters = c(
        optionsForPlot[["informativeCauchyLocation"]],
        optionsForPlot[["informativeCauchyScale"]], 1), oneSided = oneSided)
      priorUpper <- jaspTTests::.qShiftedT(.85, parameters = c(
        optionsForPlot[["informativeCauchyLocation"]],
        optionsForPlot[["informativeCauchyScale"]], 1), oneSided = oneSided)

      ci95PlusMedian <- jaspTTests::.ciPlusMedian_t(
        t                  = t, n1 = n1, n2 = n2,
        independentSamples = !paired && n2 > 0,
        prior.location     = optionsForPlot[["informativeCauchyLocation"]],
        prior.scale        = optionsForPlot[["informativeCauchyScale"]],
        prior.df           = 1,
        ci                 = .95,
        oneSided           = oneSided
      )

    } else if (optionsForPlot[["informativeStandardizedEffectSize"]] == "t") {

      ci99PlusMedian <- jaspTTests::.ciPlusMedian_t(
        t                  = t, n1 = n1, n2 = n2,
        independentSamples = !paired && n2 > 0,
        prior.location     = optionsForPlot[["informativeTLocation"]],
        prior.scale        = optionsForPlot[["informativeTScale"]],
        prior.df           = optionsForPlot[["informativeTDf"]],
        ci                 = .99,
        oneSided           = oneSided
      )

      priorLower <- jaspTTests::.qShiftedT(.15, parameters = c(
        optionsForPlot[["informativeTLocation"]],
        optionsForPlot[["informativeTScale"]],
        optionsForPlot[["informativeTDf"]]), oneSided = oneSided)
      priorUpper <- jaspTTests::.qShiftedT(.85, parameters = c(
        optionsForPlot[["informativeTLocation"]],
        optionsForPlot[["informativeTScale"]],
        optionsForPlot[["informativeTDf"]]), oneSided = oneSided)

      ci95PlusMedian <- jaspTTests::.ciPlusMedian_t(
        t                  = t, n1 = n1, n2 = n2,
        independentSamples = !paired && n2 > 0,
        prior.location     = optionsForPlot[["informativeTLocation"]],
        prior.scale        = optionsForPlot[["informativeTScale"]],
        prior.df           = optionsForPlot[["informativeTDf"]],
        ci                 = .95,
        oneSided           = oneSided
      )

    } else if (optionsForPlot[["informativeStandardizedEffectSize"]] == "normal") {

      ci99PlusMedian <- jaspTTests::.ciPlusMedian_normal(
        t                  = t, n1 = n1, n2 = n2,
        independentSamples = !paired && n2 > 0,
        prior.mean         = optionsForPlot[["informativeNormalMean"]],
        prior.variance     = optionsForPlot[["informativeNormalStd"]]^2,
        ci                 = .99,
        oneSided           = oneSided
      )

      priorLower <- qnorm(0.15, optionsForPlot[["informativeNormalMean"]], optionsForPlot[["informativeNormalStd"]])
      priorUpper <- qnorm(0.85, optionsForPlot[["informativeNormalMean"]], optionsForPlot[["informativeNormalStd"]])

      ci95PlusMedian <- jaspTTests::.ciPlusMedian_normal(
        t                  = t, n1 = n1, n2 = n2,
        independentSamples = !paired && n2 > 0,
        prior.mean         = optionsForPlot[["informativeNormalMean"]],
        prior.variance     = optionsForPlot[["informativeNormalStd"]]^2,
        ci                 = .95,
        oneSided           = oneSided
      )
    }

    CIlow           <- ci95PlusMedian[["ciLower"]]
    CIhigh          <- ci95PlusMedian[["ciUpper"]]
    medianPosterior <- ci95PlusMedian[["median"]]

    xlim[1] <- min(-2, ci99PlusMedian[["ciLower"]], priorLower)
    xlim[2] <- max(2, ci99PlusMedian[["ciUpper"]], priorUpper)

    # For raw scale: transform to raw for pretty ticks, then back to SMD for computation
    sd_val <- .getEquivalenceSd(options, analysis)
    if (!is.null(sd_val) && options[["boundstype"]] == "raw") {
      xlim_raw   <- xlim * sd_val
      xticks_raw <- pretty(xlim_raw)
      xticks     <- xticks_raw / sd_val
    } else {
      xticks <- pretty(xlim)
    }

    # Calculate prior and posterior over the whole range
    xxx <- seq(min(xticks), max(xticks), length.out = 1000)
    priorLine <- jaspTTests::.dprior_informative(xxx, oneSided = oneSided, options = optionsForPlot)
    posteriorLine <- jaspTTests::.dposterior_informative(xxx,
      t = t, n1 = n1, n2 = n2, paired = paired, oneSided = oneSided, options = optionsForPlot)

    # Calculate prior and posterior over the interval range
    if (optionsForPlot$lowerbound == -Inf) {
      xx <- seq(min(xticks), max(optionsForPlot$upperbound), length.out = 1000)
    } else if (optionsForPlot$upperbound == Inf) {
      xx <- seq(min(optionsForPlot$lowerbound), max(xticks), length.out = 1000)
    } else {
      xx <- seq(min(optionsForPlot$lowerbound), max(optionsForPlot$upperbound), length.out = 1000)
    }

    priorInterval <- jaspTTests::.dprior_informative(xx, oneSided = oneSided, options = optionsForPlot)
    posteriorInterval <- jaspTTests::.dposterior_informative(xx,
      t = t, n1 = n1, n2 = n2, paired = paired, oneSided = oneSided, options = optionsForPlot)

    xlim <- c(min(CIlow, range(xticks)[1]), max(range(xticks)[2], CIhigh))

    # Transform for raw scale display if needed
    if (!is.null(sd_val) && options[["boundstype"]] == "raw") {
      x_for_lines  <- seq(min(xticks), max(xticks), length.out = 1000L) * sd_val
      y_for_lines  <- c(posteriorLine, priorLine) / sd_val
      CRI    <- c(CIlow, CIhigh) * sd_val
      median <- medianPosterior * sd_val
    } else {
      x_for_lines  <- seq(min(xticks), max(xticks), length.out = 1000L)
      y_for_lines  <- c(posteriorLine, priorLine)
      CRI    <- c(CIlow, CIhigh)
      median <- medianPosterior
    }

    dfLines <- data.frame(
      x = x_for_lines,
      y = y_for_lines,
      g = factor(rep(c("Posterior", "Prior"), each = 1000L))
    )

    if (!addInformation) {
      BF     <- NULL
      median <- NULL
      CRI    <- NULL
    }

    # X-axis label depends on scale type
    if (!is.null(sd_val) && options[["boundstype"]] == "raw") {
      xAxisLabel <- bquote(paste(.(gettext("Mean Difference (Raw)"))))
    } else {
      xAxisLabel <- bquote(paste(.(gettext("Effect size")), ~delta))
    }

    plotPriorPosterior <- jaspGraphs::PlotPriorAndPosterior(
      dfLines,
      BF           = BF,
      CRI          = CRI,
      median       = median,
      bfType       = "BF10",
      xName        = xAxisLabel,
      bfSubscripts = jaspGraphs::parseThis(c("BF[phantom()%in%phantom()%notin%phantom()]",
                                              "BF[phantom()%notin%phantom()%in%phantom()]")),
      pizzaTxt     = jaspGraphs::parseThis(c("data~'|'~H[phantom()%notin%phantom()]",
                                              "data~'|'~H[phantom()%in%phantom()]"))
    )

    # Transform interval coordinates for display if raw scale
    if (!is.null(sd_val) && options[["boundstype"]] == "raw") {
      xx_display                   <- xx * sd_val
      priorInterval_display        <- priorInterval / sd_val
      posteriorInterval_display    <- posteriorInterval / sd_val
    } else {
      xx_display                <- xx
      priorInterval_display     <- priorInterval
      posteriorInterval_display <- posteriorInterval
    }

    ribbonData <- data.frame(
      x    = xx_display,
      ymin = 0,
      ymax = c(priorInterval_display, posteriorInterval_display),
      g    = factor(rep(1:2, each = 1000))
    )

    if (options[["priorandposteriorAdditionalInfo"]]) {
      plotPriorPosterior$subplots[[4]] <- plotPriorPosterior$subplots[[4]] +
        ggplot2::geom_ribbon(
          ribbonData,
          mapping = ggplot2::aes(x = x, ymax = ymax, ymin = ymin, group = g, fill = g),
          inherit.aes = FALSE, alpha = .5, show.legend = FALSE) +
        ggplot2::scale_fill_manual(values = c("grey", "darkgrey"))
    } else {
      plotPriorPosterior <- plotPriorPosterior +
        ggplot2::geom_ribbon(
          ribbonData,
          mapping = ggplot2::aes(x = x, ymax = ymax, ymin = ymin, group = g, fill = g),
          inherit.aes = FALSE, alpha = .5, show.legend = FALSE) +
        ggplot2::scale_fill_manual(values = c("grey", "darkgrey"))
    }

    plotPriorPosterior
  })

  if (isTryError(p)) {
    errorMessage <- gettextf("Plotting not possible: %s", .extractErrorMessage(p))
    plot$setError(errorMessage)
  } else {
    plot$plotObject <- p
  }

  return()
}

# Prior and Posterior Mass table for summary statistics
.summaryStatsEquivalenceMassTable <- function(jaspResults, results, options, analysis) {

  if (!options[["massPriorPosterior"]] || !is.null(jaspResults[["equivalenceContainer"]][["massTable"]]))
    return()

  massTable <- createJaspTable(title = gettext("Prior and Posterior Mass Table"))
  massTable$dependOn(options = "massPriorPosterior")
  massTable$position <- 3
  massTable$showSpecifiedColumnsOnly <- TRUE

  massTable$addColumnInfo(name = "section",       title = gettext("Section"),        type = "string")
  massTable$addColumnInfo(name = "priorMass",     title = gettext("Prior Mass"),     type = "number")
  massTable$addColumnInfo(name = "posteriorMass", title = gettext("Posterior Mass"), type = "number")

  jaspResults[["equivalenceContainer"]][["massTable"]] <- massTable

  if (!results[["ready"]] || jaspResults[["equivalenceContainer"]]$getError())
    return()

  massTable$addRows(list(
    section       = "\U003B4 \U02208 I",
    priorMass     = results$integralEquivalencePrior,
    posteriorMass = results$integralEquivalencePosterior
  ))

  massTable$addRows(list(
    section       = "\U003B4 \U02209 I",
    priorMass     = results$integralNonequivalencePrior,
    posteriorMass = results$integralNonequivalencePosterior
  ))

  return()
}
