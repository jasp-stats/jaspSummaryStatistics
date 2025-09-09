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
			info: qsTr("Select the type of statistical test to analyze")

			RadioButton
			{
				value: "z"
				label: qsTr("z-test")
				checked: true
				childrenOnSameRow: true
				info: qsTr("Use when population standard deviation is known")

				DoubleField
				{
					name: "zStatistic"
					label: qsTr("Test statistic:")
					defaultValue: 0
					fieldWidth: 80
					negativeValues: true
					info: qsTr("Enter the calculated z-statistic value")
				}
			}

			RadioButton
			{
				value: "t"
				label: qsTr("t-test")
				childrenOnSameRow: true
				info: qsTr("Use when sample standard deviation is used to estimate population standard deviation")

				DoubleField
				{
					name: "tStatistic"
					label: qsTr("Test statistic:")
					defaultValue: 0
					fieldWidth: 80
					negativeValues: true
					info: qsTr("Enter the calculated t-statistic value")
				}

				IntegerField
				{
					name: "tDf"
					label: qsTr("df:")
					defaultValue: 1
					min: 1
					fieldWidth: 60
					info: qsTr("Enter the degrees of freedom for the t-test")
				}
			}

			RadioButton
			{
				value: "chi2"
				label: qsTr("χ² test")
				childrenOnSameRow: true
				info: qsTr("Use for goodness of fit or independence tests")

				DoubleField
				{
					name: "chi2Statistic"
					label: qsTr("Test statistic:")
					defaultValue: 0
					min: 0
					fieldWidth: 80
					info: qsTr("Enter the calculated chi-squared statistic value")
				}

				IntegerField
				{
					name: "chi2Df"
					label: qsTr("df:")
					defaultValue: 1
					min: 1
					fieldWidth: 60
					info: qsTr("Enter the degrees of freedom for the chi-squared test")
				}
			}

			RadioButton
			{
				value: "f"
				label: qsTr("F-test")
				childrenOnSameRow: true
				info: qsTr("Use for comparing variances or in ANOVA")

				DoubleField
				{
					name: "fStatistic"
					label: qsTr("Test statistic:")
					defaultValue: 0
					min: 0
					fieldWidth: 80
					info: qsTr("Enter the calculated F-statistic value")
				}

				IntegerField
				{
					name: "fDf1"
					label: qsTr("Numerator df:")
					defaultValue: 1
					min: 1
					fieldWidth: 60
					info: qsTr("Enter the numerator degrees of freedom")
				}

				IntegerField
				{
					name: "fDf2"
					label: qsTr("Denominator df:")
					defaultValue: 1
					min: 1
					fieldWidth: 60
					info: qsTr("Enter the denominator degrees of freedom")
				}
			}
		}
	}


	RadioButtonGroup
	{
		name: "alternative"
		title: qsTr("Alternative Hypothesis")
		enabled: testType.value === "z" || testType.value === "t"
		info: qsTr("Choose the direction of the alternative hypothesis for directional tests")

		RadioButton
		{
			value: "twoSided"
			label: qsTr("Two-sided")
			checked: true
			info: qsTr("Test if the parameter differs from the null value in either direction")
		}

		RadioButton
		{
			value: "greater"
			label: qsTr("Greater")
			info: qsTr("Test if the parameter is greater than the null value")
		}

		RadioButton
		{
			value: "less"
			label: qsTr("Less")
			info: qsTr("Test if the parameter is less than the null value")
		}
	}
}