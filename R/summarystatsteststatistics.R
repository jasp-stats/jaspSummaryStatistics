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

SummaryStatsTestStatistics <- function(jaspResults, dataset = NULL, options, ...) {

  # Create the main table
  .testStatisticsCreateTable(jaspResults, options)

  return()
}

.testStatisticsCreateTable <- function(jaspResults, options) {

  if (!is.null(jaspResults[["testStatisticsTable"]]))
    return()

  # Create table
  table <- createJaspTable(title = gettext("Test Statistics"))
  table$dependOn(c("testType", "zStatistic", "tStatistic", "tDf", "chi2Statistic", "chi2Df", 
                   "fStatistic", "fDf1", "fDf2", "alternative"))
  table$position <- 1

  # Add columns
  table$addColumnInfo(name = "testType", title = gettext("Test"), type = "string")
  table$addColumnInfo(name = "statistic", title = gettext("Statistic"), type = "number")
  table$addColumnInfo(name = "df", title = gettext("df"), type = "integer")
  table$addColumnInfo(name = "df1", title = gettext("df1"), type = "integer")
  table$addColumnInfo(name = "df2", title = gettext("df2"), type = "integer")
  table$addColumnInfo(name = "pValue", title = gettext("p"), type = "pvalue")

  jaspResults[["testStatisticsTable"]] <- table

  # Compute results
  results <- .testStatisticsComputeResults(options)
  
  if (!is.null(results$error)) {
    table$setError(results$error)
    return()
  }

  # Add results to table
  table$addRows(results$row)

  return()
}



.testStatisticsComputeResults <- function(options) {
  
  testType <- options[["testType"]]
  alternative <- options[["alternative"]]
  
  if (testType == "z") {
    statistic <- options[["zStatistic"]]
    
    if (alternative == "twoSided") {
      pValue <- 2 * stats::pnorm(-abs(statistic))
    } else if (alternative == "greater") {
      pValue <- stats::pnorm(statistic, lower.tail = FALSE)
    } else if (alternative == "less") {
      pValue <- stats::pnorm(statistic, lower.tail = TRUE)
    }
    
    row <- list(
      testType = gettext("z"),
      statistic = statistic,
      df = "",
      df1 = "",
      df2 = "",
      pValue = pValue
    )
    
  } else if (testType == "t") {
    statistic <- options[["tStatistic"]]
    df <- options[["tDf"]]
    
    if (alternative == "twoSided") {
      pValue <- 2 * stats::pt(-abs(statistic), df = df)
    } else if (alternative == "greater") {
      pValue <- stats::pt(statistic, df = df, lower.tail = FALSE)
    } else if (alternative == "less") {
      pValue <- stats::pt(statistic, df = df, lower.tail = TRUE)
    }
    
    row <- list(
      testType = gettext("t"),
      statistic = statistic,
      df = df,
      df1 = "",
      df2 = "",
      pValue = pValue
    )
    
  } else if (testType == "chi2") {
    statistic <- options[["chi2Statistic"]]
    df <- options[["chi2Df"]]
    
    pValue <- stats::pchisq(statistic, df = df, lower.tail = FALSE)
    
    row <- list(
      testType = gettext("χ²"),
      statistic = statistic,
      df = df,
      df1 = "",
      df2 = "",
      pValue = pValue
    )
    
  } else if (testType == "f") {
    statistic <- options[["fStatistic"]]
    df1 <- options[["fDf1"]]
    df2 <- options[["fDf2"]]
    
    pValue <- stats::pf(statistic, df1 = df1, df2 = df2, lower.tail = FALSE)
    
    row <- list(
      testType = gettext("F"),
      statistic = statistic,
      df = "",
      df1 = df1,
      df2 = df2,
      pValue = pValue
    )
  }
  
  return(list(error = NULL, row = row))
}