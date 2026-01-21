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
		DoubleField  { label: qsTr("t");					name: "tStatistic"; negativeValues: true; visible: inputType.value === "tAndN" }
		DoubleField  { label: qsTr("Cohen's d");			name: "cohensD";	negativeValues: true; visible: inputType.value === "cohensD" }
		Group
		{
			columns: 2
			visible: inputType.value === "meanDiffAndSD"
			DoubleField  { label: qsTr("Mean difference");		name: "meanDifference"; negativeValues: true}
			DoubleField  { label: qsTr("SD");					name: "sdDifference"}
		}
		IntegerField { label: qsTr("Sample size");			name: "sampleSize" }
	}

	RadioButtonGroup
	{
		title: qsTr("Input Type")
		id:		inputType
		name:	"inputType"
		RadioButton { value: "tAndN";				label: qsTr("t and Sample Size"); checked: true }
		RadioButton { value: "cohensD";				label: qsTr("Cohen's d and Sample Size")			}
		RadioButton { value: "meanDiffAndSD";		label: qsTr("Mean Diff., SD, and Sample Size") }
	}

    Divider { }

	RadioButtonGroup
	{
		id:		hypothesis
		name:	"alternative"
		title:	qsTr("Alt. Hypothesis")
		RadioButton { value: "twoSided";	label: qsTr("Measure 1 \u2260 Measure 2"); checked: true	}
		RadioButton { value: "greater";		label: qsTr("Measure 1 > Measure 2")						}
		RadioButton { value: "less";		label: qsTr("Measure 1 < Measure 2")						}
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
