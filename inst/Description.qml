import QtQuick
import JASP.Module

Description
{
	title			: qsTr("Summary Statistics")
	description		: qsTr("Apply common Bayesian tests from sufficient statistics")
	icon			: "analysis-bayesian-ttest.svg"
	requiresData	: false
	hasWrappers: 	  false
	
	GroupTitle
	{
		title:	qsTr("Classical")
		icon:	"analysis-classical-ttest.svg"
	}
	Analysis
	{
		menu:	qsTr("Test Statistics")
		title:	qsTr("S.S. Test Statistics")
		func:	"SummaryStatsTestStatistics"
	}

	GroupTitle
	{
		title:	qsTr("T-Tests")
		icon:	"analysis-bayesian-ttest.svg"
	}
	Analysis
	{
		menu:	qsTr("Bayesian Independent Samples T-Test")
		title:	qsTr("S.S. Bayesian Independent Samples T-Test")
		func:	"SummaryStatsTTestBayesianIndependentSamples"
	}
	Analysis
	{
		menu:	qsTr("Bayesian Paired Samples T-Test")
		title:	qsTr("S.S. Bayesian Paired Samples T-Test")
		func:	"SummaryStatsTTestBayesianPairedSamples"
	}
	Analysis
	{
		menu:	qsTr("Bayesian One Sample T-Test")
		title:	qsTr("S.S. Bayesian One Sample T-Test")
		func:	"SummaryStatsTTestBayesianOneSample"
	}

	GroupTitle
	{
		title:	qsTr("Regression")
		icon:	"analysis-bayesian-regression.svg"
	}
	Analysis
	{
		menu:	qsTr("Bayesian Correlation")
		title:	qsTr("S.S. Bayesian Correlation")
		func:	"SummaryStatsCorrelationBayesianPairs"
	}
	Analysis
	{
		menu:	qsTr("Bayesian Linear Regression")
		title:	qsTr("S.S. Bayesian Linear Regression")
		func:	"SummaryStatsRegressionLinearBayesian"
	}

	GroupTitle
	{
		title: qsTr("Frequencies")
		icon: "analysis-bayesian-crosstabs.svg"
	}
	Analysis
	{
		menu:	qsTr("Bayesian Binomial Test")
		title:	qsTr("S.S. Bayesian Binomial Test")
		func:	"SummaryStatsBinomialTestBayesian"
	}
	Analysis
	{
		menu:	qsTr("Bayesian A/B Test")
		title:	qsTr("S.S. Bayesian A/B Test")
		func:	"SummaryStatsABTestBayesian"
	}

	GroupTitle
	{
		title: qsTr("Miscellaneous")
		icon: "analysis-bayesian-crosstabs.svg"
	}
	Analysis
	{
		menu:	qsTr("Bayesian Z-Test")
		title:	qsTr("S.S. Bayesian Z-Test")
		func:	"SummaryStatsBayesianZTest"
	}
	Analysis
	{
		menu:	qsTr("General Bayesian Tests")
		title:	qsTr("S.S. General Bayesian Tests")
		func:	"SummaryStatsGeneralBayesianTests"
	}
}
