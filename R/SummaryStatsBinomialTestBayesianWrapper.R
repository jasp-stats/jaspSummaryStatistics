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

#' S.S. Bayesian Binomial Test
#'
SummaryStatsBinomialTestBayesian <- function(
          data = NULL,
          version = "1",
          alternative = "twoSided",
          bayesFactorType = "BF10",
          betaPriorA = 1,
          betaPriorB = 1,
          failures = 0,
          plotHeight = 320,
          plotWidth = 480,
          priorPosteriorPlot = FALSE,
          priorPosteriorPlotAdditionalInfo = TRUE,
          successes = 0,
          testValue = 0.5) {

   options <- mget(names(formals(sys.function())), envir = environment(), inherits = FALSE)
   options[["data"]] <- NULL
   options[["version"]] <- NULL


   if (!jaspBase::jaspResultsCalledFromJasp() && !is.null(data)) {
      jaspBase::storeDataSet(data)
   }


   # Options not given in the call get their default from the form, which can depend on the other options.
   options <- options[names(options) %in% names(match.call())[-1L]]
   return(jaspBase::runWrappedAnalysis("jaspSummaryStatistics", "SummaryStatsBinomialTestBayesian", "SummaryStatsBinomialTestBayesian.qml", options, version, FALSE))
}