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

SummaryStatsTTestEquivalenceBayesianOneSample <- function(jaspResults, dataset = NULL, options, ...) {
  # Internally, common functions take sampleSizeGroupOne instead of sampleSize option
  options[["sampleSizeGroupOne"]] <- options[["sampleSize"]]
  options[["sampleSize"]] <- NULL

  # Process input type and extract SD for possible raw scale conversion
  options <- .processInputTypeOptionsEquivalence(options, "oneSample")
  .checkErrorsSummaryStatsTTest(options, "oneSample")

  # Dispatch equivalence bounds
  options <- jaspEquivalenceTTests:::.equivalenceBayesianBoundsDispatch(options)

  # Handle raw scale bounds
  sd_val <- .getEquivalenceSd(options, "oneSample")
  if (is.null(sd_val) && options[["boundstype"]] == "raw") {
    options[["boundstype"]] <- "cohensD"
    options[["effectSizeStandardized"]] <- "default"
  }
  if (!is.null(sd_val) && options[["boundstype"]] == "raw") {
    options[[".rawLowerbound"]] <- options[["lowerbound"]]
    options[[".rawUpperbound"]] <- options[["upperbound"]]
    options <- jaspEquivalenceTTests:::.equivalenceBayesianConvertRawToSMD(options, sd_val)
  }

  # Compute and display
  results <- .summaryStatsEquivalenceTTestMainFunction(jaspResults, options, "oneSample")
  .summaryStatsEquivalencePriorPosteriorPlot(jaspResults, results, options, "oneSample")
  .summaryStatsEquivalenceMassTable(jaspResults, results, options, "oneSample")

  return()
}
