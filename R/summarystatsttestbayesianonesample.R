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

SummaryStatsTTestBayesianOneSample <- function(jaspResults, dataset = NULL, options, ...) {
  # Internally, common functions take sampleSizeGroupOne instead of sampleSize option
  options[["sampleSizeGroupOne"]] <- options[["sampleSize"]]
  options[["sampleSize"]] <- NULL

  # Reading in a datafile is not necessary
  # Check user input for possible errors
  options <- .processInputTypeOptions(options, "oneSample")
  .checkErrorsSummaryStatsTTest(options, "oneSample")

  # Compute the results and create main results table
  summaryStatsOneSampleResults <- .summaryStatsTTestMainFunction(jaspResults, options, "oneSample")
  # Output plots
  .ttestBayesianPriorPosteriorPlotSummaryStats(jaspResults, summaryStatsOneSampleResults, options)
  .ttestBayesianPlotRobustnessSummaryStats(jaspResults, summaryStatsOneSampleResults, options)

  return()
}
