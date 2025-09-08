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
import JASP

Form
{
	Group
	{
		title: qsTr("Test Type")
		
		RadioButtonGroup
		{
			name: "testType"
			id: testType

			RadioButton
			{
				value: "z"
				label: qsTr("z-test")
				checked: true
				childrenOnSameRow: true

				DoubleField
				{
					name: "zStatistic"
					label: qsTr("Test statistic:")
					defaultValue: 0
					fieldWidth: 80
					negativeValues: true
				}
			}

			RadioButton
			{
				value: "t"
				label: qsTr("t-test")
				childrenOnSameRow: true

				DoubleField
				{
					name: "tStatistic"
					label: qsTr("Test statistic:")
					defaultValue: 0
					fieldWidth: 80
					negativeValues: true
				}

				IntegerField
				{
					name: "tDf"
					label: qsTr("df:")
					defaultValue: 1
					min: 1
					fieldWidth: 60
				}
			}

			RadioButton
			{
				value: "chi2"
				label: qsTr("χ² test")
				childrenOnSameRow: true

				DoubleField
				{
					name: "chi2Statistic"
					label: qsTr("Test statistic:")
					defaultValue: 0
					min: 0
					fieldWidth: 80
				}

				IntegerField
				{
					name: "chi2Df"
					label: qsTr("df:")
					defaultValue: 1
					min: 1
					fieldWidth: 60
				}
			}

			RadioButton
			{
				value: "f"
				label: qsTr("F-test")
				childrenOnSameRow: true

				DoubleField
				{
					name: "fStatistic"
					label: qsTr("Test statistic:")
					defaultValue: 0
					min: 0
					fieldWidth: 80
				}

				IntegerField
				{
					name: "fDf1"
					label: qsTr("Numerator df:")
					defaultValue: 1
					min: 1
					fieldWidth: 60
				}

				IntegerField
				{
					name: "fDf2"
					label: qsTr("Denominator df:")
					defaultValue: 1
					min: 1
					fieldWidth: 60
				}
			}
		}
	}

	Group
	{
		title: qsTr("Hypothesis")

		RadioButtonGroup
		{
			name: "alternative"
			title: qsTr("Alternative Hypothesis")
			enabled: testType.value === "z" || testType.value === "t"

			RadioButton
			{
				value: "twoSided"
				label: qsTr("Two-sided")
				checked: true
			}

			RadioButton
			{
				value: "greater"
				label: qsTr("Greater")
			}

			RadioButton
			{
				value: "less"
				label: qsTr("Less than 0")
			}
		}
	}
}