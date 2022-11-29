
import QtQuick		2.12
import JASP.Module	1.0

Upgrades
{
    Upgrade
    {
        functionName:		"SummaryStatsCorrelationBayesianPairs"
        fromVersion:		"0.16.3"
        toVersion:			"0.16.4"

        ChangeJS
        {
            name:		"alternative"
            jsFunction:	function(options)
            {
                switch(options["alternative"])
                {
                    case "two.sided":				return "twoSided"	;
                    default:                        return options["alternative"];
                }
            }
        }

        ChangeRename { from: "ciValue";                                 to: "ciLevel"                               }

        // Prior posterior plots
        ChangeRename { from: "plotPriorPosterior";						to: "priorPosteriorPlot"					}
        ChangeRename { from: "plotPriorPosteriorAddEstimationInfo";		to: "priorPosteriorPlotAddEstimationInfo"	}
        ChangeRename { from: "plotPriorPosteriorAddTestingInfo";		to: "priorPosteriorPlotAddTestingInfo"		}


        // Bf Robustness plots
        ChangeRename { from: "plotBfRobustness";						to: "bfRobustnessPlot"						}
        ChangeRename { from: "plotBfRobustnessAddInfo";					to: "bfRobustnessPlotAddInfo"				}

        // Prior
        ChangeRename { from: "kappa";									to: "priorWidth"							}
    }

    Upgrade
    {
        functionName:		"SummaryStatsCorrelationBayesianPairs"
        fromVersion:		"0.16.4"
        toVersion:			"0.17.0"

        // Prior posterior plots
        ChangeRename { from: "priorPosteriorPlotAddEstimationInfo";		to: "priorPosteriorPlotAdditionalEstimationInfo"	}
        ChangeRename { from: "priorPosteriorPlotAddTestingInfo";		to: "priorPosteriorPlotAdditionalTestingInfo"		}

        // Bf Robustness plots
        ChangeRename { from: "bfRobustnessPlotAddInfo";					to: "bfRobustnessPlotAdditionalInfo"				}
    }

    Upgrade
    {
        functionName:       "SummaryStatsABTestBayesian"
        fromVersion:        "0.16.4"
        toVersion:          "0.17.0"

        ChangeRename{	from: "normal_mu";					to: "normalPriorMean"				}
		ChangeRename{	from: "normal_sigma";				to: "normalPriorSd"					}
		ChangeRename{	from: "descriptives";				to: "descriptivesTable"				}
		ChangeRename{	from: "plotPriorAndPosterior";		to: "priorPosteriorPlot"			}
		ChangeRename{	from: "plotPosteriorType";			to: "priorPosteriorPlotType"		}
		ChangeJS
		{
			name:		"priorPosteriorPlotType"
			jsFunction:	function(options)
			{
				switch(options["priorPosteriorPlotType"])
				{
					case "LogOddsRatio":		return "logOddsRatio";
					case "OddsRatio":			return "oddsRatio";
					case "RelativeRisk":		return "relativeRisk";
					case "AbsoluteRisk":		return "absoluteRisk";
					case "p1&p2":				return "p1P2";
				}
			}
		}
		ChangeRename{	from: "plotSequentialAnalysis";		to: "bfSequentialPlot"		}
		ChangeRename{	from: "plotPriorOnly";				to: "priorPlot"						}
		ChangeRename{	from: "plotPriorType";				to: "priorPlotType"					}
		ChangeJS
		{
			name:		"priorPlotType"
			jsFunction:	function(options)
			{
				switch(options["priorPlotType"])
				{
					case "LogOddsRatio":		return "logOddsRatio";
					case "OddsRatio":			return "oddsRatio";
					case "RelativeRisk":		return "relativeRisk";
					case "AbsoluteRisk":		return "absoluteRisk";
					case "p1&p2":				return "p1P2";
					default:					return options["priorPlotType"];
				}
			}
		}
		ChangeRename{	from: "plotRobustness";						to: "bfRobustnessPlot"					}
		ChangeRename{	from: "plotRobustnessBFType";				to: "bfRobustnessPlotType"				}
		ChangeRename{	from: "orEqualTo1Prob";						to: "priorModelProbabilityEqual"		}
		ChangeRename{	from: "orGreaterThan1Prob";					to: "priorModelProbabilityGreater"		}
		ChangeRename{	from: "orLessThan1Prob";					to: "priorModelProbabilityLess"			}
		ChangeRename{	from: "orNotEqualTo1Prob";					to: "priorModelProbabilityTwoSided"		}
		ChangeRename{	from: "numSamples";							to: "samples"							}
		ChangeRename{	from: "mu_stepsize";						to: "bfRobustnessPlotStepsPriorMean"		}
		ChangeRename{	from: "sigma_stepsize";						to: "bfRobustnessPlotStepsPriorSd"		}
		ChangeRename{	from: "mu_stepsize_lower";					to: "bfRobustnessPlotLowerPriorMean"		}
		ChangeRename{	from: "mu_stepsize_upper";					to: "bfRobustnessPlotUpperPriorMean"		}
		ChangeRename{	from: "sigma_stepsize_lower";				to: "bfRobustnessPlotLowerPriorSd"		}
		ChangeRename{	from: "sigma_stepsize_upper";				to: "bfRobustnessPlotUpperPriorSd"		}
    }

    Upgrade
    {
        functionName:       "SummaryStatsBayesianZTest"
        fromVersion:        "0.16.4"
        toVersion:          "0.17.0"

        ChangeRename{   from: "hypothesis"; to: "alternative"   }
        ChangeJS
        {
            name:       "alternative"
            jsFunction: function(options)
            {
                switch(options["alternative"])
                {
                    case "notEqualToTestValue":     return "twoSided";
                    case "greaterThanTestValue":    return "greater";
                    case "lessThanTestValue":       return "less";
                }
            }
        }
        ChangeRename{ from: "plotPriorAndPosterior";		            to: "priorPosteriorPlot"			        }
        ChangeRename{ from: "plotPriorAndPosteriorAdditionalInfo";		to: "priorPosteriorPlotAdditionalInfo"	    }
        ChangeRename{ from: "plotBayesFactorRobustness";                to: "bfRobustnessPlot"                      }
        ChangeRename{ from: "robustnessPriorMeanMin";                   to: "bfRobustnessPlotPriorMeanMin"          }
        ChangeRename{ from: "robustnessPriorMeanMax";                   to: "bfRobustnessPlotPriorMeanMax"          }
        ChangeRename{ from: "robustnessPriorSdMin";                     to: "bfRobustnessPlotPriorSdMin"            }
        ChangeRename{ from: "robustnessPriorSdMax";                     to: "bfRobustnessPlotPriorSdMax"            }
        ChangeRename{ from: "plotBayesFactorRobustnessContours";        to: "bfRobustnessPlotPriorContour"          }
        ChangeRename{ from: "plotBayesFactorRobustnessContoursValues";       to: "bfRobustnessPlotPriorContourValues"    }

    }

    Upgrade
    {
        functionName:       "SummaryStatsBinomialTestBayesian"
        fromVersion:        "0.16.4"
        toVersion:          "0.17.0"

        ChangeRename{   from: "hypothesis"; to: "alternative"   }
        ChangeJS
        {
            name:       "alternative"
            jsFunction: function(options)
            {
                switch(options["alternative"])
                {
                    case "notEqualToTestValue":     return "twoSided";
                    case "greaterThanTestValue":    return "greater";
                    case "lessThanTestValue":       return "less";
                }
            }
        }
        ChangeRename{	from: "plotPriorAndPosterior";					to: "priorPosteriorPlot"			    }
		ChangeRename{	from: "plotPriorAndPosteriorAdditionalInfo";	to: "priorPosteriorPlotAdditionalInfo"	}
        ChangeRename{	from: "betaPriorParamA";	to: "betaPriorA"	}
        ChangeRename{	from: "betaPriorParamB";	to: "betaPriorB"	}
    }

    Upgrade
    {
        functionName:       "SummaryStatsGeneralBayesianTests"
        fromVersion:		"0.16.4"
        toVersion:			"0.17.0"

        ChangeRename{ from: "plotPriors";           to: "priorPlot"         }
        ChangeRename{ from: "plotPredictions";      to: "predictionPlot"    }
        ChangeRename{ from: "plotLikelihood";       to: "likelihoodPlot"    }
        ChangeRename{ from: "plotPosteriors";       to: "posteriorPlot"     }
        ChangeRename{ from: "plotPosteriorsPriors"; to: "posteriorPlotPrior"}

    }

    Upgrade
    {
        functionName:       "SummaryStatsRegressionLinearBayesian"
        fromVersion:		"0.16.4"
        toVersion:			"0.17.0"

        ChangeRename{ from: "numberOfCovariatesNull";                   to: "nullNumberOfCovariates"         }
        ChangeRename{ from: "unadjustedRSquaredNull";                   to: "nullUnadjustedRSquared"         }
        ChangeRename{ from: "numberOfCovariatesAlternative";            to: "alternativeNumberOfCovariates"         }
        ChangeRename{ from: "unadjustedRSquaredAlternative";            to: "alternativeNumberOfCovariates"         }
        ChangeRename{ from: "plotBayesFactorRobustness";                to: "bfRobustnessPlot"         }
        ChangeRename{ from: "plotBayesFactorRobustnessAdditionalInfo";  to: "bfRobustnessPlotAdditionalInfo"         }
        ChangeRename{ from: "priorWidth";                               to: "priorRScale"         }
    }

    Upgrade
    {
        functionName:       "SummaryStatsTTestBayesianOneSample"
        fromVersion:		"0.16.4"
        toVersion:			"0.17.0"

        ChangeRename{ from: "n1Size"; to: "sampleSize"}
        ChangeRename{   from: "hypothesis"; to: "alternative"   }
        ChangeJS
        {
            name:       "alternative"
            jsFunction: function(options)
            {
                switch(options["alternative"])
                {
                    case "notEqualToTestValue":     return "twoSided";
                    case "greaterThanTestValue":    return "greater";
                    case "lessThanTestValue":       return "less";
                }
            }
        }
        ChangeRename{	from: "plotPriorAndPosterior";					    to: "priorPosteriorPlot"			    }
		ChangeRename{	from: "plotPriorAndPosteriorAdditionalInfo";	    to: "priorPosteriorPlotAdditionalInfo"	}
        ChangeRename{	from: "plotBayesFactorRobustness";				    to: "bfRobustnessPlot"					}
        ChangeRename{	from: "plotBayesFactorRobustnessAdditionalInfo";	to: "bfRobustnessPlotAdditionalInfo"	}
    }

    Upgrade
    {
        functionName:       "SummaryStatsTTestBayesianIndependentSamples"
        fromVersion:		"0.16.4"
        toVersion:			"0.17.0"

        ChangeRename{ from: "n1Size"; to: "sampleSizeGroupOne"}
        ChangeRename{ from: "n2Size"; to: "sampleSizeGroupTwo"}
        ChangeRename{   from: "hypothesis"; to: "alternative"   }
        ChangeJS
        {
            name:       "alternative"
            jsFunction: function(options)
            {
                switch(options["alternative"])
                {
                    case "groupsNotEqual":     return "twoSided";
                    case "groupOneGreater":    return "greater";
                    case "groupTwoGreater":    return "less";
                }
            }
        }
        ChangeRename{	from: "plotPriorAndPosterior";					    to: "priorPosteriorPlot"			    }
		ChangeRename{	from: "plotPriorAndPosteriorAdditionalInfo";	    to: "priorPosteriorPlotAdditionalInfo"	}
        ChangeRename{	from: "plotBayesFactorRobustness";				    to: "bfRobustnessPlot"					}
        ChangeRename{	from: "plotBayesFactorRobustnessAdditionalInfo";	to: "bfRobustnessPlotAdditionalInfo"	}
    }

    Upgrade
    {
        functionName:       "SummaryStatsTTestBayesianPairedSamples"
        fromVersion:		"0.16.4"
        toVersion:			"0.17.0"

        ChangeRename{ from: "n1Size"; to: "sampleSize"}
        ChangeRename{   from: "hypothesis"; to: "alternative"   }
        ChangeJS
        {
            name:       "alternative"
            jsFunction: function(options)
            {
                switch(options["alternative"])
                {
                    case "groupsNotEqual":     return "twoSided";
                    case "groupOneGreater":    return "greater";
                    case "groupTwoGreater":    return "less";
                }
            }
        }
        ChangeRename{	from: "plotPriorAndPosterior";					    to: "priorPosteriorPlot"			    }
		ChangeRename{	from: "plotPriorAndPosteriorAdditionalInfo";	    to: "priorPosteriorPlotAdditionalInfo"	}
        ChangeRename{	from: "plotBayesFactorRobustness";				    to: "bfRobustnessPlot"					}
        ChangeRename{	from: "plotBayesFactorRobustnessAdditionalInfo";	to: "bfRobustnessPlotAdditionalInfo"	}
    }
}
