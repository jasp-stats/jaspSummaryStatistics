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
		DoubleField  { name: "tStatistic";	label: qsTr("t"); 			negativeValues: true; visible: inputType.value === "tAndN"	}
		DoubleField  { name: "cohensD";		label: qsTr("Cohen's d");;	negativeValues: true; visible: inputType.value === "cohensD"}
		Group
		{
			columns: 2
			visible: inputType.value === "meanAndSD"
			DoubleField  { name: "mean";		label: qsTr("Mean"); negativeValues: true}
			DoubleField  { name: "sd";			label: qsTr("SD")}
		}	
		DoubleField  { name: "testValue";	label: qsTr("Test value");  visible: inputType.value === "meanAndSD" }
		IntegerField { name: "sampleSize";	label: qsTr("Sample size")				}
	}

	RadioButtonGroup
	{
		id:		inputType
		name:	"inputType"
		title: qsTr("Input Type")
		RadioButton { value: "tAndN";		label: qsTr("t and Sample Size"); checked: true	}
		RadioButton { value: "cohensD";		label: qsTr("Cohen's d and Sample Size")			}
		RadioButton { value: "meanAndSD";	label: qsTr("Mean, SD, and Sample Size")			}
	}

    Divider { }

	RadioButtonGroup
	{
		id:		hypothesis
		title:	qsTr("Alt. Hypothesis")
		name:	"alternative"
		RadioButton { value: "twoSided";	label: qsTr("\u2260 Test value"); checked: true	}
		RadioButton { value: "greater";		label: qsTr("> Test value")						}
		RadioButton { value: "less";		label: qsTr("< Test value")						}
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
