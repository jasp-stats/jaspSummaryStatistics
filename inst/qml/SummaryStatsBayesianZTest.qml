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
import JASP.Controls 1.0
import JASP.Widgets 1.0


Form
{

	Group
	{

		Layout.columnSpan:	2
		DropDown
		{
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
				dataEs.editingFinished();
				dataLCi.editingFinished();
				dataUCi.editingFinished();
			}
		}

		FormulaField
		{
			
			name:			"dataEs"
			id:				dataEs
			label:			data.value == "esAndCiLog"	? qsTr("Effect size log") : qsTr("Effect size")
			value:			data.value == "esAndCiLog"	? "1"				: "0"
			min:			data.value == "esAndSe"		? -Infinity			: dataLCi.value
			max:			data.value == "esAndSe"		?  Infinity			: dataUCi.value
			fieldWidth:		60
		}

		FormulaField
		{
			name:			"dataSe"
			label:			qsTr("SE")
			visible:		data.value == "esAndSe"
			value:			"1"
			min:			0
			fieldWidth:		60
		}

		FormulaField
		{
			name:			"dataSd"
			label:			qsTr("Sd")
			visible:		data.value == "esAndN"
			value:			"1"
			min:			0
			fieldWidth:		60
		}

		FormulaField
		{
			name:			"dataN"
			label:			qsTr("N")
			visible:		data.value == "esAndN"
			value:			"1"
			min:			0
			fieldWidth:		60
		}

		Group
		{
			columns:	2
			title:		data.value == "esAndCiLog"	? qsTr("Confidence interval log") : qsTr("Confidence interval")
			visible:	data.value == "esAndCi" || data.value == "esAndCiLog"

			FormulaField
			{
				name:			"dataLCi"
				id:				dataLCi
				label:			qsTr("lower")
				value:			data.value == "esAndCiLog" ? "0.5"	: "-1"
				min:			data.value == "esAndCiLog" ? 0		: -Infinity
				max:			dataUCi.value
				fieldWidth:		60
			}

			FormulaField
			{
				name:			"dataUCi"
				id:				dataUCi
				label:			qsTr("upper")
				value:			data.value == "esAndCiLog" ? "2"	: "1"
				min:			dataLCi.value
				fieldWidth:		60
			}
		}
	}


	Divider	{}

	Group
	{
		RadioButtonGroup
		{
			title:	qsTr("Alt. Hypothesis")
			name:	"hypothesis"
			id:		hypothesis
			RadioButton { value: "notEqualToTestValue";		label: qsTr("\u2260 Test value"); checked: true	}
			RadioButton { value: "greaterThanTestValue";	label: qsTr("> Test value")						}
			RadioButton { value: "lessThanTestValue";		label: qsTr("< Test value")						}
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

		BayesFactorType	{}

		CheckBox
		{
			name:	"defaultBf"
			label:	qsTr("Default Bayes factor")
			
			DropDown
			{
				name:	"defaultBfType"
				label:	qsTr("")
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
				visible:		defaultBfType.value == "custom"
			}

		}

	}


	Group
	{
		title:	qsTr("Plots")

		CheckBox
		{
			name:	"plotPriorAndPosterior"
			label:	qsTr("Prior and posterior")

			CheckBox
			{
				name:		"plotPriorAndPosteriorAdditionalInfo"
				label:		qsTr("Additional info")
				checked:	true
			}
		}

		CheckBox
		{
			name:	"plotBayesFactorRobustness"
			label:	qsTr("Bayes factor robustness check")
			

			Group
			{
				columns:	2
				DoubleField
				{
					label:			qsTr("Prior mean   min:")
					name:			"robustnessPriorMeanMin"
					id:				robustnessPriorMeanMin
					defaultValue:	hypothesis.value == "greaterThanTestValue" ? 0 : -1
					fieldWidth:		50
					negativeValues:	true
					max:			robustnessPriorMeanMax.value
				}

				DoubleField
				{
					label:			qsTr("max:")
					name:			"robustnessPriorMeanMax"
					id:				robustnessPriorMeanMax
					defaultValue:	hypothesis.value == "lessThanTestValue" ? 0 : 1
					fieldWidth:		50
					negativeValues:	true
					min:			robustnessPriorMeanMin.value
				}

				DoubleField
				{
					label:			qsTr("Prior std	min:")
					name:			"robustnessPriorSdMin"
					id:				robustnessPriorSdMin
					defaultValue:	0
					fieldWidth:		50
					max:			robustnessPriorSdMax.value
				}

				DoubleField
				{
					label:			qsTr("max")
					name:			"robustnessPriorSdMax"
					id:				robustnessPriorSdMax
					defaultValue:	1
					fieldWidth:		50
					min:			robustnessPriorSdMin.value
				}
			}

			CheckBox
			{
				name:				"plotBayesFactorRobustnessContours"
				childrenOnSameRow:	true

				FormulaField
				{
					name:			"plotBayesFactorRobustnessContoursValues"
					label:			qsTr("Specify Bayes factor contours")
					value:			"1/100, 1/30, 1/10, 1/3, 1, 3, 10, 30, 100"
					fieldWidth:		125
				}
			}
		}
	}

}
