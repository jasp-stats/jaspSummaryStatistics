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
		DoubleField  { name: "tStatistic";		label: qsTr("t"); 			negativeValues: true; visible: inputType.value === "tAndN"	}
		DoubleField  { name: "cohensD";			label: qsTr("Cohen's d");	negativeValues: true; visible: inputType.value === "cohensD"}
		Group
		{
			columns: 2
			visible: inputType.value === "meanDiffAndSD"
			DoubleField  { name: "meanDifference";	label: qsTr("Mean Difference"); negativeValues: true}
			DoubleField  { name: "sdDifference";	label: qsTr("SD Difference")}
		}
		IntegerField { name: "sampleSize";		label: qsTr("Sample size")				}
	}

	RadioButtonGroup
	{
		id:		inputType
		name:	"inputType"
		title: qsTr("Input Type")
		RadioButton { value: "tAndN";			label: qsTr("t and Sample Size"); checked: true	}
		RadioButton { value: "cohensD";			label: qsTr("Cohen's d and Sample Size")			}
		RadioButton { value: "meanDiffAndSD";	label: qsTr("Mean Difference, SD, and Sample Size")	}
	}

	Divider { }

	Group
	{
		title: qsTr("Equivalence Region")
		columns: 2

		RadioButtonGroup
		{
			name: "equivalenceRegion"
			GridLayout
			{
				columns: 3
				rowSpacing: jaspTheme.rowGroupSpacing
				columnSpacing: 0
				visible: alternative.value === "twoSided"

				RadioButton { value: "region"; checked: true; id: region}
				DoubleField { name: "lowerbound"; label: qsTr("from"); max: upperbound.value; defaultValue: -0.05; id: lowerbound; negativeValues: true; inclusive: JASP.None}
				DoubleField { name: "upperbound"; label: qsTr("to"); min: lowerbound.value; defaultValue: 0.05; id: upperbound; negativeValues: true; Layout.leftMargin: jaspTheme.columnGroupSpacing; inclusive: JASP.None}

				RadioButton { value: "lower"; id: lower }
				Label		{ text: qsTr("from %1").arg(" -\u221E ")}
				DoubleField { name: "lower_max"; label: qsTr("to"); id: lower_max; defaultValue: 0.05; negativeValues: true; Layout.leftMargin: jaspTheme.columnGroupSpacing; inclusive: JASP.None}

				RadioButton { value: "upper"; id: upper }
				DoubleField { name: "upper_min"; label: qsTr("from"); id: upper_min; defaultValue: -0.05; negativeValues: true}
				Label		{ text: qsTr("to %1").arg(" \u221E "); Layout.leftMargin: jaspTheme.columnGroupSpacing}
			}

			GridLayout
			{
				columns: 2
				rowSpacing: jaspTheme.rowGroupSpacing
				columnSpacing: 0
				visible: alternative.value === "greater"

				Label		{ text: qsTr("from %1").arg(" 0 ")}
				DoubleField { name: "upperbound_greater"; label: qsTr("to"); min: 0; defaultValue: 0.05; negativeValues: false; Layout.leftMargin: jaspTheme.columnGroupSpacing; inclusive: JASP.None}
			}

			GridLayout
			{
				columns: 2
				rowSpacing: jaspTheme.rowGroupSpacing
				columnSpacing: 0
				visible: alternative.value === "less"

				DoubleField { name: "lowerbound_less"; label: qsTr("from"); max: 0; defaultValue: -0.05; negativeValues: true; inclusive: JASP.None}
				Label		{ text: qsTr("to %1").arg(" 0 "); Layout.leftMargin: jaspTheme.columnGroupSpacing}
			}
		}

		DropDown
		{
			Layout.columnSpan: 2
			name: "boundstype"
			id: boundstype
			label: qsTr("Bounds specification in")
			indexDefaultValue: 0
			enabled: inputType.value === "meanDiffAndSD"
			onCurrentValueChanged: if (value === "raw") {
				effectSizeStandardized.value = "raw"
			} else if (value === "cohensD") {
				effectSizeStandardized.value = "default"
			}
			values:
			[
				{ value: "cohensD", label: qsTr("Cohen's d")	},
				{ value: "raw",     label: qsTr("Raw")			}
			]
		}
	}

	RadioButtonGroup
	{
		id:		alternative
		name:	"alternative"
		title:	qsTr("Alt. Hypothesis")
		RadioButton { value: "twoSided";	label: qsTr("Measure 1 \u2260 Measure 2"); checked: true	}
		RadioButton { value: "greater";		label: qsTr("Measure 1 > Measure 2")						}
		RadioButton { value: "less";		label: qsTr("Measure 1 < Measure 2")						}
	}

	Group
	{
		title: qsTr("Additional Statistics")
		CheckBox { name: "massPriorPosterior";	text: qsTr("Prior and posterior mass") }
	}

	Group
	{
		title: qsTr("Plots")
		CheckBox
		{
			name: "priorandposterior";							label: qsTr("Prior and posterior")
			CheckBox { name: "priorandposteriorAdditionalInfo";	label: qsTr("Additional info"); checked: true }
		}
	}

	BayesFactorType { correlated: alternative.value }

	Section
	{
		title: qsTr("Prior")

		RadioButtonGroup
		{
			name: "effectSizeStandardized"
			id:	effectSizeStandardized

			RadioButton
			{
				id: defaultPriors
				label: qsTr("Default"); name: "default"
				checked: boundstype.value === "cohensD"
				visible: boundstype.value === "cohensD"
				RadioButtonGroup
				{
					name: "defaultStandardizedEffectSize"
					RadioButton
					{
						label: qsTr("Cauchy"); name: "cauchy"; checked: true; childrenOnSameRow: true
						DoubleField { label: qsTr("scale"); name: "priorWidth"; defaultValue: 0.707; fieldWidth: 50; max: 2; inclusive: JASP.MaxOnly }
					}
				}
			}

			RadioButton
			{
				id: informativePriors
				label: qsTr("Informative"); name: "informative"
				visible: boundstype.value === "cohensD"
				RadioButtonGroup
				{
					name: "informativeStandardizedEffectSize"
					RadioButton
					{
						label: qsTr("Cauchy"); name: "cauchy"; checked: true; childrenOnSameRow: true; id: cauchyInformative
						DoubleField { label: qsTr("location:"); name: "informativeCauchyLocation"; visible: cauchyInformative.checked; defaultValue: 0; min: -3; max: 3 }
						DoubleField { label: qsTr("scale:"); name: "informativeCauchyScale"; visible: cauchyInformative.checked; defaultValue: 0.707; fieldWidth: 50; max: 2; inclusive: JASP.MaxOnly }
					}
					RadioButton
					{
						label: qsTr("Normal"); name: "normal"; childrenOnSameRow: true; id: normalInformative
						DoubleField { label: qsTr("mean:"); name: "informativeNormalMean"; visible: normalInformative.checked; defaultValue: 0; min: -3; max: 3 }
						DoubleField { label: qsTr("std:"); name: "informativeNormalStd"; visible: normalInformative.checked; defaultValue: 0.707; fieldWidth: 50; max: 2 }
					}
					RadioButton
					{
						label: qsTr("t"); name: "t"; childrenOnSameRow: true; id: tInformative
						DoubleField { label: qsTr("location:"); name: "informativeTLocation"; visible: tInformative.checked; defaultValue: 0; min: -3; max: 3 }
						DoubleField { label: qsTr("scale:"); name: "informativeTScale"; visible: tInformative.checked; defaultValue: 0.707; fieldWidth: 50; max: 2; inclusive: JASP.MaxOnly }
						DoubleField { label: qsTr("df:"); name: "informativeTDf"; visible: tInformative.checked; defaultValue: 1; min: 1; max: 100 }
					}
				}
			}

			RadioButton
			{
				id: rawPriors
				label: qsTr("Raw"); name: "raw"
				visible: boundstype.value === "raw"
				checked: boundstype.value === "raw"
				RadioButtonGroup
				{
					name: "rawEffectSize"
					RadioButton
					{
						label: qsTr("Cauchy"); name: "cauchy"; checked: true; childrenOnSameRow: true; id: cauchyRaw
						DoubleField { label: qsTr("location:"); name: "rawCauchyLocation"; visible: cauchyRaw.checked; defaultValue: 0; negativeValues: true }
						DoubleField { label: qsTr("scale:"); name: "rawCauchyScale"; visible: cauchyRaw.checked; defaultValue: 0.707; fieldWidth: 50; negativeValues: false }
					}
					RadioButton
					{
						label: qsTr("Normal"); name: "normal"; childrenOnSameRow: true; id: normalRaw
						DoubleField { label: qsTr("mean:"); name: "rawNormalMean"; visible: normalRaw.checked; defaultValue: 0; negativeValues: true }
						DoubleField { label: qsTr("std:"); name: "rawNormalStd"; visible: normalRaw.checked; defaultValue: 0.707; fieldWidth: 50; negativeValues: false }
					}
					RadioButton
					{
						label: qsTr("t"); name: "t"; childrenOnSameRow: true; id: tRaw
						DoubleField { label: qsTr("location:"); name: "rawTLocation"; visible: tRaw.checked; defaultValue: 0; negativeValues: true }
						DoubleField { label: qsTr("scale:"); name: "rawTScale"; visible: tRaw.checked; defaultValue: 0.707; fieldWidth: 50; negativeValues: false }
						DoubleField { label: qsTr("df:"); name: "rawTDf"; visible: tRaw.checked; defaultValue: 1; min: 1; max: 100 }
					}
				}
			}
		}
	}
}
