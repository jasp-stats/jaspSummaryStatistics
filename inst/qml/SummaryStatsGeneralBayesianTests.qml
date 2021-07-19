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
		Layout.columnSpan: 2

		DropDown
		{
			label:				qsTr("Likelihood")
			id:					likelihood
			name:				"likelihood"
			values:
			[
				{ label: qsTr("Normal"),				value: "normal"},
				{ label: qsTr("Student-t"),				value: "t"},
				{ label: qsTr("Binomial"),				value: "binomial"},
				{ label: qsTr("Non-central d"),			value: "nonCentralD"},
				{ label: qsTr("Non-central t"),			value: "nonCentralT"}
			]
			//onValueChanged:		if (likelihood.value == "binomial") {
			// - TODO: set trunctation to interval 0-1 for all hypotheses
			// - allow only some priors
			//}
		}

		Group
		{
			title:			qsTr("Data:")

			FormulaField
			{
				name:			"dataMean"
				label:			qsTr("Mean")
				visible:		likelihood.value == "normal" || likelihood.value == "t"
				value:			"0"
				fieldWidth:     60
			}

			FormulaField
			{
				name:			"dataT"
				label:			qsTr("t-statistic")
				visible:		likelihood.value == "nonCentralT"
				value:			"0"
				fieldWidth:     60
			}

			FormulaField
			{
				name:			"dataD"
				label:			qsTr("d")
				visible:		likelihood.value == "nonCentralD"
				value:			"0"
				fieldWidth:     60
			}

			FormulaField
			{
				name:			"dataSd"
				label:			qsTr("SD")
				visible:		likelihood.value == "normal" || likelihood.value == "t"
				value:			"1"
				min:			0
				fieldWidth:     60
			}

			IntegerField
			{
				name:			"dataDf"
				label:			qsTr("Df")
				visible:		likelihood.value == "t" || likelihood.value == "nonCentralT"
				defaultValue:	25
				min:			1
			}

			IntegerField
			{
				name:			"dataSuccesses"
				label:			qsTr("Successes")
				id:				dataSuccesses
				visible:		likelihood.value == "binomial"
				defaultValue:	5
				min:			1
				max:			dataObservations.value
			}

			IntegerField
			{
				name:			"dataObservations"
				label:			qsTr("Observations")
				id:				dataObservations
				visible:		likelihood.value == "binomial" || likelihood.value == "nonCentralD"
				defaultValue:	10
				min:			dataSuccesses.value
			}
		}

	}
	

    Divider { }

	ColumnLayout
	{
		spacing:				0
		Layout.preferredWidth:	parent.width
		visible:				!measuresFitted.checked
		Layout.columnSpan:		2

		Label { text: qsTr("Null Hypothesis"); Layout.preferredHeight: 20 * preferencesModel.uiScale}


		RowLayout
		{
			Label { text: qsTr("Distribution");	Layout.preferredWidth: 140 * preferencesModel.uiScale; Layout.leftMargin: 5 * preferencesModel.uiScale}
			Label { text: qsTr("Parameters");	Layout.preferredWidth: 155 * preferencesModel.uiScale }
			Label { text: qsTr("Truncation");	Layout.preferredWidth: 150 * preferencesModel.uiScale }
		}

		RowLayout
		{

			Row
			{
				spacing: 4 * preferencesModel.uiScale
				Layout.preferredWidth: 140 * preferencesModel.uiScale
				DropDown
				{
					id: nullItem
					name: "nullType"
					useExternalBorder: true
					values:
					[
						{ label: qsTr("Spike(x₀)"),				value: "spike"},
						{ label: qsTr("Normal(μ,σ)"),			value: "normal"},
						{ label: qsTr("Student-t(μ,σ,v)"),		value: "t"},
						{ label: qsTr("Cauchy(x₀,θ)"),			value: "cauchy"},
						{ label: qsTr("Beta(α,β)"),				value: "beta"},
						{ label: qsTr("Uniform(a,b)"),			value: "uniform"}
					]
				}
			}

			Row
			{
				spacing: 4 * preferencesModel.uiScale
				Layout.preferredWidth: 155 * preferencesModel.uiScale
				FormulaField
				{
					label:				"μ "
					name:				"nullParMean"
					visible:			nullItem.currentValue === "normal"		||
										nullItem.currentValue === "t"
					value:				"0"
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"x₀"
					name:				"nullParLocation"
					id:					nullParLocation
					visible:			nullItem.currentValue === "cauchy"	||
										nullItem.currentValue === "spike"
					value:				likelihood.currentValue == "binomial" ?  "0.5" : "0"
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true

					Connections
					{
						target: likelihood
						function onCurrentValueChanged() {
							nullParLocation.value =	likelihood.currentValue == "binomial" ?  0.5 : 0
							nullParLocation.editingFinished()
						}
					}
				}
				FormulaField
				{
					label:				"σ"
					name:				"nullParScale"
					visible:			nullItem.currentValue === "normal"		||
										nullItem.currentValue === "t"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"θ"
					name:				"nullParScale2"
					visible:			nullItem.currentValue === "cauchy"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"ν"
					name:				"nullParDf"
					visible:			nullItem.currentValue === "t"
					value:				"2"
					min:				1
					inclusive:			JASP.MinOnly
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"α "
					name:				"nullParAlpha"
					visible:			nullItem.currentValue === "beta"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"β"
					name:				"nullParBeta"
					visible:			nullItem.currentValue === "beta"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"a "
					name:				"nullParA"
					id:					nullParA
					visible:			nullItem.currentValue === "uniform"
					value:				"0"
					max:				nullParB.value
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"b"
					name:				"nullParB"
					id:					nullParB
					visible:			nullItem.currentValue === "uniform"
					value:				"1"
					min:				nullParA.value
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
			}

			Row
			{
				spacing: 4 * preferencesModel.uiScale
				Layout.preferredWidth: 150 * preferencesModel.uiScale
				FormulaField
				{
					id:					truncationNullLower
					label: 				qsTr("lower")
					name: 				"nullTruncationLower"
					visible:			nullItem.currentValue !== "spike" && nullItem.currentValue !== "uniform" && nullItem.currentValue !== "beta"
					value:				likelihood.currentValue == "binomial" ?  0 : "-Inf"
					min:				likelihood.currentValue == "binomial" ?  0 : "-Inf"
					max: 				truncationNullUpper.value
					inclusive: 			JASP.MinOnly
					fieldWidth:			40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder:			true

					Connections
					{
						target: likelihood
						function onCurrentValueChanged() {
							truncationNullLower.value =	likelihood.currentValue == "binomial" ?  0 : "-Inf"
							truncationNullLower.editingFinished()
						}
					}
				}
				FormulaField
				{
					id:					truncationNullUpper
					label: 				qsTr("upper")
					name: 				"nullTruncationUpper"
					visible:			nullItem.currentValue !== "spike" && nullItem.currentValue !== "uniform" && nullItem.currentValue !== "beta"
					value:				likelihood.currentValue == "binomial" ?  1 : "Inf"
					min: 				truncationNullLower ? truncationNullLower.value : 0
					max:				likelihood.currentValue == "binomial" ?  1 : "Inf"
					inclusive: 			JASP.MaxOnly
					fieldWidth:			40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder:			true

					Connections
					{
						target: likelihood
						function onCurrentValueChanged() {
							truncationNullUpper.value =	likelihood.currentValue == "binomial" ?  1 : "Inf"
							truncationNullUpper.editingFinished()
						}
					}
				}
			}
		}
	}

	ColumnLayout
	{
		spacing:				0
		Layout.preferredWidth:	parent.width
		visible:				!measuresFitted.checked
		Layout.columnSpan:		2

		Label { text: qsTr("Alternative Hypothesis"); Layout.preferredHeight: 20 * preferencesModel.uiScale}


		RowLayout
		{
			Label { text: qsTr("Distribution");	Layout.preferredWidth: 140 * preferencesModel.uiScale; Layout.leftMargin: 5 * preferencesModel.uiScale}
			Label { text: qsTr("Parameters");	Layout.preferredWidth: 155 * preferencesModel.uiScale }
			Label { text: qsTr("Truncation");	Layout.preferredWidth: 150 * preferencesModel.uiScale }
		}
		ComponentsList
		{
			name:					"priorsAlt"
			optionKey:				"name"
			defaultValues: 			[{"type": "normal"}]
			rowComponent: 			RowLayout
			{
				Row
				{
					spacing: 4 * preferencesModel.uiScale
					Layout.preferredWidth: 140 * preferencesModel.uiScale
					DropDown
					{
						id: alternativeItem
						name: "type"
						useExternalBorder: true
						values:
						[
							{ label: qsTr("Normal(μ,σ)"),			value: "normal"},
							{ label: qsTr("Student-t(μ,σ,v)"),		value: "t"},
							{ label: qsTr("Cauchy(x₀,θ)"),			value: "cauchy"},
							{ label: qsTr("Beta(α,β)"),				value: "beta"},
							{ label: qsTr("Uniform(a,b)"),			value: "uniform"},
							{ label: qsTr("Spike(x₀)"),				value: "spike"}
						]
					}
				}

				Row
				{
					spacing: 4 * preferencesModel.uiScale
					Layout.preferredWidth: 155 * preferencesModel.uiScale
					FormulaField
					{
						label:				"μ "
						name:				"parMean"
						visible:			alternativeItem.currentValue === "normal"		||
											alternativeItem.currentValue === "t"
						value:				"0"
						inclusive:			JASP.None
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true
					}
					FormulaField
					{
						label:				"x₀"
						name:				"parLocation"
						id:					altParLocation
						visible:			alternativeItem.currentValue === "cauchy"	||
											alternativeItem.currentValue === "spike"
						value:				"0"
						inclusive:			JASP.None
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true

						Connections
						{
							target: likelihood
							function onCurrentValueChanged() {
								altParLocation.value =	likelihood.currentValue == "binomial" ?  0.5 : 0
								altParLocation.editingFinished()
							}
						}
					}
					FormulaField
					{
						label:				"σ"
						name:				"parScale"
						visible:			alternativeItem.currentValue === "normal"		||
											alternativeItem.currentValue === "t"
						value:				"1"
						min:				0
						inclusive:			JASP.None
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true
					}
					FormulaField
					{
						label:				"θ"
						name:				"parScale2"
						visible:			alternativeItem.currentValue === "cauchy"
						value:				"1"
						min:				0
						inclusive:			JASP.None
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true
					}
					FormulaField
					{
						label:				"ν"
						name:				"parDf"
						visible:			alternativeItem.currentValue === "t"
						value:				"2"
						min:				1
						inclusive:			JASP.MinOnly
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true
					}
					FormulaField
					{
						label:				"α "
						name:				"parAlpha"
						visible:			alternativeItem.currentValue === "beta"
						value:				"1"
						min:				0
						inclusive:			JASP.None
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true
					}
					FormulaField
					{
						label:				"β"
						name:				"parBeta"
						visible:			alternativeItem.currentValue === "beta"
						value:				"1"
						min:				0
						inclusive:			JASP.None
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true
					}
					FormulaField
					{
						label:				"a "
						name:				"parA"
						id:					parA
						visible:			alternativeItem.currentValue === "uniform"
						value:				"0"
						max:				parB.value
						inclusive:			JASP.None
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true
					}
					FormulaField
					{
						label:				"b"
						name:				"parB"
						id:					parB
						visible:			alternativeItem.currentValue === "uniform"
						value:				"1"
						min:				parA.value
						inclusive:			JASP.None
						fieldWidth: 		40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder: 		true
					}
				}

				Row
				{
					spacing: 4 * preferencesModel.uiScale
					Layout.preferredWidth: 150 * preferencesModel.uiScale
					FormulaField
					{
						id:					truncationAltLower
						label: 				qsTr("lower")
						name: 				"truncationLower"
						visible:			alternativeItem.currentValue !== "spike" && alternativeItem.currentValue !== "uniform" && alternativeItem.currentValue !== "beta"
						value:				likelihood.currentValue == "binomial" ?  0 : "-Inf"
						min:				likelihood.currentValue == "binomial" ?  0 : "-Inf"
						max: 				truncationAltUpper.value
						inclusive: 			JASP.MinOnly
						fieldWidth:			40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder:			true

						Connections
						{
							target: likelihood
							function onCurrentValueChanged() {
								truncationAltLower.value =	likelihood.currentValue == "binomial" ?  0 : "-Inf"
								truncationAltLower.editingFinished()
							}
						}
					}
					FormulaField
					{
						id:					truncationAltUpper
						label: 				qsTr("upper")
						name: 				"truncationUpper"
						visible:			alternativeItem.currentValue !== "spike" && alternativeItem.currentValue !== "uniform" && alternativeItem.currentValue !== "beta"
						value:				likelihood.currentValue == "binomial" ?  1 : "Inf"
						min: 				truncationAltLower ? truncationAltLower.value : 0
						max:				likelihood.currentValue == "binomial" ?  1 : "Inf"
						inclusive: 			JASP.MaxOnly
						fieldWidth:			40 * preferencesModel.uiScale
						useExternalBorder:	false
						showBorder:			true

						Connections
						{
							target: likelihood
							function onCurrentValueChanged() {
								truncationAltUpper.value =	likelihood.currentValue == "binomial" ?  1 : "Inf"
								truncationAltUpper.editingFinished()
							}
						}
					}
				}
			}
		}
	}

	Divider { }

	Group
	{
		title:		qsTr("Plots")

		CheckBox
		{
			name:		"plotPriors"
			label:		qsTr("Priors")
		}

		CheckBox
		{
			name:		"plotPredictions"
			label:		qsTr("Prior predictions")
			
			// TODO: potencial update
			//CheckBox
			//{
			//	name:		"plotPredictionsRatio"
			//	label:		qsTr("Show ratio")
			//}
		}

		CheckBox
		{
			name:		"plotLikelihood"
			label:		qsTr("Likelihood")
		}
		
		CheckBox
		{
			name:		"plotPosteriors"
			label:		qsTr("Posteriors")

			CheckBox
			{
				name:		"plotPosteriorsPriors"
				label:		qsTr("Priors")
			}
		}
	}

	BayesFactorType { }
}
