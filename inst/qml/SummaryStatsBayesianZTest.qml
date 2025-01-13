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


import QtQuick
import QtQuick.Layouts
import JASP.Controls


Form
{

	Group
	{

		Layout.columnSpan:	2
		DropDown
		{
			property string lastValue: "esAndSe"

			label:				qsTr("Data")
			id:					data
			name:				"dataType"
			values:
			[
				{ label: qsTr("Effect size & SE"),			value: "esAndSe"},
				{ label: qsTr("Effect size & CI"),			value: "esAndCi"},
				{ label: qsTr("Effect size & CI (log)"),	value: "esAndCiLog"},
				{ label: qsTr("Effect size, SD & N"),		value: "esAndN"}
			]
			onValueChanged:
			{
				if(!initialized)
					return

				if(value === "esAndCiLog"){
					dataEs.value	= "1";
					dataLCi.value	= "exp(-1.96)";
					dataUCi.value	= "exp(1.96)";
					dataEs.editingFinished();
					dataLCi.editingFinished();
					dataUCi.editingFinished()
				}else if(lastValue === "esAndCiLog"){
					dataEs.value	= "0";
					dataLCi.value	= "-1.96";
					dataUCi.value	= "1.96";
					dataEs.editingFinished();
					dataLCi.editingFinished();
					dataUCi.editingFinished()
				}
				lastValue = value
			}
		}

		FormulaField
		{
			name:			"dataEs"
			id:				dataEs
			label:			data.value === "esAndCiLog"	? qsTr("Effect size log") : qsTr("Effect size")
			value:			"0"
			min:			data.value === "esAndSe"		? -Infinity			: dataLCi.value
			max:			data.value === "esAndSe"		?  Infinity			: dataUCi.value
			fieldWidth:		60
		}

		FormulaField
		{
			name:			"dataSe"
			label:			qsTr("SE")
			visible:		data.value === "esAndSe"
			value:			"1"
			min:			0
			fieldWidth:		60
		}

		FormulaField
		{
			name:			"dataSd"
			label:			qsTr("Sd")
			visible:		data.value === "esAndN"
			value:			"1"
			min:			0
			fieldWidth:		60
		}

		FormulaField
		{
			name:			"dataN"
			label:			qsTr("N")
			visible:		data.value === "esAndN"
			value:			"1"
			min:			0
			fieldWidth:		60
		}

		Group
		{
			columns:	2
			title:		data.value === "esAndCiLog"	? qsTr("Confidence interval log") : qsTr("Confidence interval")
			visible:	data.value === "esAndCi" || data.value === "esAndCiLog"

			FormulaField
			{
				name:			"dataLCi"
				id:				dataLCi
				label:			qsTr("lower")
				value:			"-1.96"
				min:			data.value === "esAndCiLog" ? 0		: -Infinity
				max:			dataUCi.value
				fieldWidth:		80
			}

			FormulaField
			{
				name:			"dataUCi"
				id:				dataUCi
				label:			qsTr("upper")
				value:			"1.96"
				min:			dataLCi.value
				fieldWidth:		80
			}
		}
	}


	Divider	{}

	Group
	{
		RadioButtonGroup
		{
			title:	qsTr("Alt. Hypothesis")
			name:	"alternative"
			id:		hypothesis
			RadioButton { value: "twoSided";	label: qsTr("\u2260 Test value"); checked: true	}
			RadioButton { value: "greater";		label: qsTr("> Test value")						}
			RadioButton { value: "less";		label: qsTr("< Test value")						}
		}

		Group
		{
			title:		qsTr("Prior Distribution")
			columns:	2
			FormulaField
			{
				name:			"priorMean"
				label:			qsTr("Normal   mean:")
				value:			"0"
				fieldWidth:		60
			}

			FormulaField
			{
				name:			"priorSd"
				label:			qsTr("std")
				value:			"1"
				min:			0
				fieldWidth:		60
			}
		}

		BayesFactorType	{ correlated: hypothesis.value }

		CheckBox
		{
			name:	"defaultBf"
			label:	qsTr("Default Bayes factor")
			
			DropDown
			{
				name:	"defaultBfType"
				label:	""
				id:		defaultBfType

				values:
				[
					{ label: qsTr("Select effect size"),	value: "select"},				
					{ label: qsTr("Cohen's d"),				value: "cohensD"},
					{ label: qsTr("log(OR)"),				value: "logOr"},
					{ label: qsTr("log(HR)"),				value: "logHr"},
					{ label: qsTr("Custom"),				value: "custom"}
				]
			}

			DoubleField
			{
				label:			qsTr("Unit information SD")
				name:			"defaultBfSd"
				defaultValue:	1
				min:			0
				fieldWidth:		50
				visible:		defaultBfType.value === "custom"
			}

		}

	}


	Group
	{
		title:	qsTr("Plots")

		CheckBox
		{
			name:	"priorPosteriorPlot"
			label:	qsTr("Prior and posterior")

			CheckBox
			{
				name:		"priorPosteriorPlotAdditionalInfo"
				label:		qsTr("Additional info")
				checked:	true
			}
		}

		CheckBox
		{
			name:	"bfRobustnessPlot"
			label:	qsTr("Bayes factor robustness check")
			

			Group
			{
				columns:	2
				DoubleField
				{
					label:			qsTr("Prior mean   min:")
					name:			"bfRobustnessPlotPriorMeanMin"
					id:				robustnessPriorMeanMin
					defaultValue:	hypothesis.value === "greater" ? 0 : -1
					fieldWidth:		50
					negativeValues:	true
					max:			robustnessPriorMeanMax.value
				}

				DoubleField
				{
					label:			qsTr("max:")
					name:			"bfRobustnessPlotPriorMeanMax"
					id:				robustnessPriorMeanMax
					defaultValue:	hypothesis.value === "less" ? 0 : 1
					fieldWidth:		50
					negativeValues:	true
					min:			robustnessPriorMeanMin.value
				}

				DoubleField
				{
					label:			qsTr("Prior std	min:")
					name:			"bfRobustnessPlotPriorSdMin"
					id:				robustnessPriorSdMin
					defaultValue:	0
					fieldWidth:		50
					max:			robustnessPriorSdMax.value
				}

				DoubleField
				{
					label:			qsTr("max")
					name:			"bfRobustnessPlotPriorSdMax"
					id:				robustnessPriorSdMax
					defaultValue:	1
					fieldWidth:		50
					min:			robustnessPriorSdMin.value
				}
			}

			CheckBox
			{
				name:				"bfRobustnessPlotPriorContour"
				label:				qsTr("Specify Bayes factor contours")

				FormulaField
				{
					name:			"bfRobustnessPlotPriorContourValues"
					label:			""
					value:			"1/100, 1/30, 1/10, 1/3, 1, 3, 10, 30, 100"
					fieldWidth:		250
				}
			}
		}
	}

}
