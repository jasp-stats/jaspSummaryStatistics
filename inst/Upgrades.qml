
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
}
