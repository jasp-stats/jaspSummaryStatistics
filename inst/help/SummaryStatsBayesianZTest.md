Summary Statistics Bayesian Z-Test
===

This function allows you to compute Bayes factor corresponding to a z-test using the effect size estimate and its standard error (or confidence interval). The null hypothesis states that the population mean equals a specific constant, i.e., the test value. This Bayesian assessment can be executed in the absence of the raw data.

### Assumptions
- The observations are a random sample from the population
- The dependent variable is normally distributed
- The population variance is known

### Input
---
#### Assignment Box
- Effect size
- Standard error or confidence  interval

The effect size and confidence interval of odds or hazard ratios can be supplied on the original scale via the `Effect size & CI (log)` argument. JASP then internally transforms the input on the log scale for the subsequent computations.

### Prior
  - *Normal*: Mean and Standard deviation

#### Alt. Hypothesis
- *&ne; Test value*: Two-sided alternative hypothesis that the population mean is not equal to the test value
- *&gt; Test value*: One-sided alternative hypothesis that the population mean is larger than the test value
- *&lt; Test value*: One-sided alternative hypothesis that the population mean is smaller than the test value

#### Bayes Factor
- *BF10*: Bayes factor to quantify evidence for the alternative hypothesis relative to the null hypothesis
- *BF01*: Bayes factor to quantify evidence for the null hypothesis relative to the alternative hypothesis
- *Log(BF10)*: Natural logarithm of BF10

#### Default Bayes Factor
Computes a default Bayes factor based on a unit information prior centered at zero effect size. The specified unit information priors for the usual effect sizes are based on Spiegelhalter, Abrams, & Myles (2004) and correspond to a normal distribution with mean and standard deviation:
- Cohen's d: Normal(0, 2)
- log(OR): Normal(0, 2)
- log(HR): Normal(0, 2)
The `Custom` option allows users to specify the width of their own unit information prior distribution.

#### Plots
- *Prior and posterior*: Displays the prior (dashed line) and posterior (solid line) density of the effect size under the alternative hypothesis; the gray circles represent the height of the prior and the posterior density at effect size delta = 0. The horizontal solid line represents the width of the 95% credible interval of the posterior.
  - Additional info: Adds the Bayes factor computed with the user-defined prior; adds a probability wheel depicting the odds of the data under the null vs. alternative hypothesis; adds the median and the 95% credible interval of the posterior density of the effect size
- *Bayes factor robustness check*: Displays the Bayes factor as a function of the mean (x-axis) and standard deviation (y-axis) the Normal prior distribution on effect size. The range of robustness check can be specified via the `min` and `max` options.
  - Specify Bayes factor contours: Specify levels of the individual contours.


### Output
---
- **Bayes factor**
  - BF+0: Bayes factor that quantifies evidence for the one-sided alternative hypothesis that the population mean is larger than the test value.
  - BF-0: Bayes factor that quantifies evidence for the one-sided alternative hypothesis that the population mean is smaller than the test value.
  - BF0+: Bayes factor that quantifies evidence for the null hypothesis relative to the one-sided alternative hypothesis that the population mean is larger than the test value.
  - BF0-: Bayes factor that quantifies evidence for the null hypothesis relative to the one-sided alternative hypothesis that the population mean is smaller than the test value.
  - max(BF): Maximum Bayes factor, i.e., Bayes factor comparing a point hypothesis located at the observed effect size to the alternative hypotheses. No prior specification can result in larger evidence in favour of the alternative hypothesis.
  - Default BF: Bayes factor corresponding to the unit information prior (if selected).


### References
---
- Spiegelhalter, D. J., Abrams, K. R., & Myles, J. P. (2004). Bayesian approaches to clinical trials and health-care evaluation. John Wiley & Sons.
- Jeffreys, H. (1961). *Theory of probability (3rd ed.)*. Oxford, UK: Oxford University Press.


### R Packages
---
- ggplot2
- stats
