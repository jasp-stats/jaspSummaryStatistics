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

#' S.S. Bayesian Z-Test
#'
SummaryStatsBayesianZTest <- function(
          data = NULL,
          version = "1",
          alternative = "twoSided",
          bayesFactorType = "BF10",
          bfRobustnessPlot = FALSE,
          bfRobustnessPlotPriorContour = FALSE,
          bfRobustnessPlotPriorContourValues = "1/100, 1/30, 1/10, 1/3, 1, 3, 10, 30, 100",
          bfRobustnessPlotPriorMeanMax = 1,
          bfRobustnessPlotPriorMeanMin = -1,
          bfRobustnessPlotPriorSdMax = 1,
          bfRobustnessPlotPriorSdMin = 0,
          dataEs = 0,
          dataLCi = -1.96,
          dataN = 1,
          dataSd = 1,
          dataSe = 1,
          dataType = "esAndSe",
          dataUCi = 1.96,
          defaultBf = FALSE,
          defaultBfSd = 1,
          defaultBfType = "select",
          plotHeight = 320,
          plotWidth = 480,
          priorMean = 0,
          priorPosteriorPlot = FALSE,
          priorPosteriorPlotAdditionalInfo = TRUE,
          priorSd = 1) {

   options <- mget(names(formals(sys.function())), envir = environment(), inherits = FALSE)
   options[["data"]] <- NULL
   options[["version"]] <- NULL


   if (!jaspBase::jaspResultsCalledFromJasp() && !is.null(data)) {
      jaspBase::storeDataSet(data)
   }

   optionsWithFormula <- c("dataType", "defaultBfType")
   for (name in optionsWithFormula) {
      if ((name %in% optionsWithFormula) && inherits(options[[name]], "formula")) options[[name]] = jaspBase::jaspFormula(options[[name]], data)   }

   # Options not given in the call get their default from the form, which can depend on the other options.
   options <- options[names(options) %in% names(match.call())[-1L]]
   return(jaspBase::runWrappedAnalysis("jaspSummaryStatistics", "SummaryStatsBayesianZTest", "SummaryStatsBayesianZTest.qml", options, version, FALSE))
}