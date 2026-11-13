#
# Copyright (C) 2013-2025 University of Amsterdam
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

# This is a generated file. Don't change it!

#' S.S. Bayesian Paired Samples T-Test
#'
SummaryStatsTTestBayesianPairedSamples <- function(
          data = NULL,
          version = "1",
          alternative = "twoSided",
          bayesFactorType = "BF10",
          bfRobustnessPlot = FALSE,
          bfRobustnessPlotAdditionalInfo = TRUE,
          cohensD = 0,
          defaultStandardizedEffectSize = "cauchy",
          dienesEffectSize = "uniform",
          effectSize = "standardized",
          effectSizeStandardized = "default",
          halfNormalDienesStd = 0.707,
          informativeCauchyLocation = 0,
          informativeCauchyScale = 0.707,
          informativeNormalMean = 0,
          informativeNormalStd = 0.707,
          informativeStandardizedEffectSize = "cauchy",
          informativeTDf = 1,
          informativeTLocation = 0,
          informativeTScale = 0.707,
          inputType = "tAndN",
          meanDifference = 0,
          normalDienesMean = 0.707,
          normalDienesStd = 0.707,
          plotHeight = 320,
          plotWidth = 480,
          priorPosteriorPlot = FALSE,
          priorPosteriorPlotAdditionalInfo = TRUE,
          priorWidth = 0.707,
          sampleSize = 0,
          sdDifference = 0,
          tStatistic = 0,
          uniformDienesLowerBound = 0.707,
          uniformDienesUpperBound = 0.707) {

   options <- mget(names(formals(sys.function())), envir = environment(), inherits = FALSE)
   options[["data"]] <- NULL
   options[["version"]] <- NULL


   if (!jaspBase::jaspResultsCalledFromJasp() && !is.null(data)) {
      jaspBase::storeDataSet(data)
   }


   # Options not given in the call get their default from the form, which can depend on the other options.
   options <- options[names(options) %in% names(match.call())[-1L]]
   return(jaspBase::runWrappedAnalysis("jaspSummaryStatistics", "SummaryStatsTTestBayesianPairedSamples", "SummaryStatsTTestBayesianPairedSamples.qml", options, version, FALSE))
}