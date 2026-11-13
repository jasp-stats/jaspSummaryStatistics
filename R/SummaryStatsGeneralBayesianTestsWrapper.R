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

#' S.S. General Bayesian Tests
#'
SummaryStatsGeneralBayesianTests <- function(
          data = NULL,
          version = "1",
          bayesFactorType = "BF10",
          dataD = 0,
          dataDf = 25,
          dataMean = 0,
          dataObservations = 10,
          dataObservationsGroup1 = 10,
          dataObservationsGroup2 = 10,
          dataSd = 1,
          dataSuccesses = 5,
          dataT = 0,
          likelihood = "normal",
          likelihoodPlot = FALSE,
          nullParA = 0,
          nullParAlpha = 1,
          nullParB = 1,
          nullParBeta = 1,
          nullParDf = 2,
          nullParLocation = 0,
          nullParMean = 0,
          nullParScale = 1,
          nullParScale2 = 1,
          nullTruncationLower = -inf,
          nullTruncationUpper = inf,
          nullType = "spike",
          plotHeight = 320,
          plotWidth = 480,
          posteriorPlot = FALSE,
          posteriorPlotPrior = FALSE,
          predictionPlot = FALSE,
          priorPlot = FALSE,
          priorsAlt = list(list(name = "#", type = "normal"))) {

   options <- mget(names(formals(sys.function())), envir = environment(), inherits = FALSE)
   options[["data"]] <- NULL
   options[["version"]] <- NULL


   if (!jaspBase::jaspResultsCalledFromJasp() && !is.null(data)) {
      jaspBase::storeDataSet(data)
   }

   optionsWithFormula <- c("likelihood", "nullType", "priorsAlt")
   for (name in optionsWithFormula) {
      if ((name %in% optionsWithFormula) && inherits(options[[name]], "formula")) options[[name]] = jaspBase::jaspFormula(options[[name]], data)   }

   # Options not given in the call get their default from the form, which can depend on the other options.
   options <- options[names(options) %in% names(match.call())[-1L]]
   return(jaspBase::runWrappedAnalysis("jaspSummaryStatistics", "SummaryStatsGeneralBayesianTests", "SummaryStatsGeneralBayesianTests.qml", options, version, FALSE))
}