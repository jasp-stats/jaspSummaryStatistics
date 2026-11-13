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

#' S.S. Bayesian A/B Test
#'
SummaryStatsABTestBayesian <- function(
          data = NULL,
          version = "1",
          bayesFactorOrder = "bestModelTop",
          bayesFactorType = "BF10",
          bfRobustnessPlot = FALSE,
          bfRobustnessPlotLowerPriorMean = -0.5,
          bfRobustnessPlotLowerPriorSd = 0.1,
          bfRobustnessPlotStepsPriorMean = 5,
          bfRobustnessPlotStepsPriorSd = 5,
          bfRobustnessPlotType = "BF10",
          bfRobustnessPlotUpperPriorMean = 0.5,
          bfRobustnessPlotUpperPriorSd = 1,
          bfSequentialPlot = FALSE,
          descriptivesTable = FALSE,
          n1 = 0,
          n2 = 0,
          normalPriorMean = 0,
          normalPriorSd = 1,
          plotHeight = 320,
          plotWidth = 480,
          priorModelProbabilityEqual = 0.5,
          priorModelProbabilityGreater = 0.25,
          priorModelProbabilityLess = 0.25,
          priorModelProbabilityTwoSided = 0,
          priorPlot = FALSE,
          priorPlotType = "logOddsRatio",
          priorPosteriorPlot = FALSE,
          priorPosteriorPlotType = "logOddsRatio",
          samples = 10000,
          seed = 1,
          setSeed = FALSE,
          y1 = 0,
          y2 = 0) {

   options <- mget(names(formals(sys.function())), envir = environment(), inherits = FALSE)
   options[["data"]] <- NULL
   options[["version"]] <- NULL


   if (!jaspBase::jaspResultsCalledFromJasp() && !is.null(data)) {
      jaspBase::storeDataSet(data)
   }

   optionsWithFormula <- c("bfRobustnessPlotType", "priorPlotType", "priorPosteriorPlotType")
   for (name in optionsWithFormula) {
      if ((name %in% optionsWithFormula) && inherits(options[[name]], "formula")) options[[name]] = jaspBase::jaspFormula(options[[name]], data)   }

   # Options not given in the call get their default from the form, which can depend on the other options.
   options <- options[names(options) %in% names(match.call())[-1L]]
   return(jaspBase::runWrappedAnalysis("jaspSummaryStatistics", "SummaryStatsABTestBayesian", "SummaryStatsABTestBayesian.qml", options, version, FALSE))
}