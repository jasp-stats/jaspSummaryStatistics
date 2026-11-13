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

#' S.S. Bayesian Correlation
#'
SummaryStatsCorrelationBayesianPairs <- function(
          data = NULL,
          version = "1",
          alternative = "twoSided",
          bayesFactorType = "BF10",
          bfRobustnessPlot = FALSE,
          bfRobustnessPlotAdditionalInfo = TRUE,
          ci = FALSE,
          ciLevel = 0.95,
          method = "pearson",
          n = 0,
          plotHeight = 320,
          plotWidth = 480,
          priorPosteriorPlot = FALSE,
          priorPosteriorPlotAdditionalEstimationInfo = TRUE,
          priorPosteriorPlotAdditionalTestingInfo = TRUE,
          priorWidth = 1,
          rObs = 0,
          rhoSObs = 0,
          tauObs = 0) {

   options <- mget(names(formals(sys.function())), envir = environment(), inherits = FALSE)
   options[["data"]] <- NULL
   options[["version"]] <- NULL


   if (!jaspBase::jaspResultsCalledFromJasp() && !is.null(data)) {
      jaspBase::storeDataSet(data)
   }


   # Options not given in the call get their default from the form, which can depend on the other options.
   options <- options[names(options) %in% names(match.call())[-1L]]
   return(jaspBase::runWrappedAnalysis("jaspSummaryStatistics", "SummaryStatsCorrelationBayesianPairs", "SummaryStatsCorrelationBayesianPairs.qml", options, version, FALSE))
}