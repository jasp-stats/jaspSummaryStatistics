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

#' S.S. Test Statistics
#'
#' @param alternative, Choose the direction of the alternative hypothesis for directional tests
#' \itemize{
#'   \item \code{"twoSided"}: Test if the parameter differs from the null value in either direction
#'   \item \code{"greater"}: Test if the parameter is greater than the null value
#'   \item \code{"less"}: Test if the parameter is less than the null value
#' }
#' @param chi2Df, Enter the degrees of freedom for the chi-squared test
#' @param chi2Statistic, Enter the calculated chi-squared statistic value
#' @param fDf1, Enter the numerator degrees of freedom
#' @param fDf2, Enter the denominator degrees of freedom
#' @param fStatistic, Enter the calculated F-statistic value
#' @param tDf, Enter the degrees of freedom for the t-test
#' @param tStatistic, Enter the calculated t-statistic value
#' @param testType, Select the type of statistical test to analyze
#' \itemize{
#'   \item \code{"z"}: Use when population standard deviation is known
#'   \item \code{"t"}: Use when sample standard deviation is used to estimate population standard deviation
#'   \item \code{"chi2"}: Use for goodness of fit or independence tests
#'   \item \code{"f"}: Use for comparing variances or in ANOVA
#' }
#' @param zStatistic, Enter the calculated z-statistic value
SummaryStatsTestStatistics <- function(
          data = NULL,
          version = "1",
          alternative = "twoSided",
          chi2Df = 1,
          chi2Statistic = 0,
          fDf1 = 1,
          fDf2 = 1,
          fStatistic = 0,
          plotHeight = 320,
          plotWidth = 480,
          tDf = 1,
          tStatistic = 0,
          testType = "z",
          zStatistic = 0) {

   options <- mget(names(formals(sys.function())), envir = environment(), inherits = FALSE)
   options[["data"]] <- NULL
   options[["version"]] <- NULL


   if (!jaspBase::jaspResultsCalledFromJasp() && !is.null(data)) {
      jaspBase::storeDataSet(data)
   }


   # Options not given in the call get their default from the form, which can depend on the other options.
   options <- options[names(options) %in% names(match.call())[-1L]]
   return(jaspBase::runWrappedAnalysis("jaspSummaryStatistics", "SummaryStatsTestStatistics", "SummaryStatsTestStatistics.qml", options, version, FALSE))
}