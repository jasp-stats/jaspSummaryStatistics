//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//


import QtQuick 2.8
import QtQuick.Layouts 1.3
import JASP.Controls
import JASP.Widgets


Form
{

	Group
	{
		DoubleField  { name: "tStatistic";				label: qsTr("t"); 			visible: inputType.value === "tAndN";	negativeValues: true }
		DoubleField  { name: "cohensD";					label: qsTr("Cohen's d");	visible: inputType.value === "cohensD";	negativeValues: true }
		Group
		{
			columns: 2
			visible: inputType.value === "meansAndSDs"
			DoubleField  { name: "mean1";					label: qsTr("Mean 1"); negativeValues: true}	
			DoubleField  { name: "sd1";						label: qsTr("SD 1")}
		}
		Group
		{
			columns: 2
			visible: inputType.value === "meansAndSDs"
			DoubleField  { name: "mean2";					label: qsTr("Mean 2"); negativeValues: true}
			DoubleField  { name: "sd2";						label: qsTr("SD 2")}
		}
		IntegerField { name: "sampleSizeGroupOne";		label: qsTr("Sample size group 1")				}
		IntegerField { name: "sampleSizeGroupTwo";		label: qsTr("Sample size group 2")				}
    }

	RadioButtonGroup
	{
		id:		inputType
		name:	"inputType"
		title: qsTr("Input Type")
		RadioButton { value: "tAndN";			label: qsTr("t and Sample Sizes"); checked: true	}
		RadioButton { value: "cohensD";			label: qsTr("Cohen's d and Sample Sizes")			}
		RadioButton { value: "meansAndSDs";		label: qsTr("Means, SDs, and Sample Sizes")			}
	}

    Divider { }

	RadioButtonGroup
	{
		id:		hypothesis
		title:	qsTr("Alt. Hypothesis")
		name:	"alternative"
		RadioButton { value: "twoSided";	label: qsTr("Group 1 \u2260 Group 2"); checked: true	}
		RadioButton { value: "greater";	  label: qsTr("Group 1 > Group 2")						}
		RadioButton { value: "less";	    label: qsTr("Group 1 < Group 2")						}
	}

	Group
	{
		title: qsTr("Plots")
		CheckBox
		{
			name: "priorPosteriorPlot";		label: qsTr("Prior and posterior")
			CheckBox { name: "priorPosteriorPlotAdditionalInfo";		label: qsTr("Additional info"); checked: true }
		}
		CheckBox
		{
			name: "bfRobustnessPlot";	label: qsTr("Bayes factor robustness check")
			CheckBox { name: "bfRobustnessPlotAdditionalInfo";	label: qsTr("Additional info"); checked: true }
		}
	}

	BayesFactorType { correlated: hypothesis.value }

    SubjectivePriors { }
}
