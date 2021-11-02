Summary Statistics General Bayesian Tests
====================================

The general Bayesian tests allows one to test a hypothesis about a parameter under different data likelihoods and is based on the methodology developed and promoted by Zoltan Dienes (e.g., Dienes 2014; Dienes & Mclatchie, 2018)


### Input
---------

#### Data
The input data needs to contain the following elements:

- Likelihood specifying the distribution of the data
  - Normal with mean and standard deviation
  - Student-t with location, scale, and degrees of freedom
  - Binomial with number of successes and total number of observations
  - Non-central d with effect size and sample size
  - Non-central t with t-statistics and degrees of freedom


#### Null hypothesis
The specification of the null hypothesis for the parameter.


#### Alternative hypotheses
The specification of posibly multiple alternative hypotheses for the parameter.


#### Plots
  - Priors: Plot parameter prior distributions.
  - Prior predictions: Plot prior predictive distributions.
  - Likelihood: Plot data likelihood.
  - Posteriors: Plot parameter posterior distributions.
  - Priors: Add prior distribution to the posterior distribution plots. 


#### Bayes Factor
- BF<sub>10</sub>: By selecting this option, the Bayes factor will show evidence for the alternative hypothesis relative to the null hypothesis. This option is selected by default.
- BF<sub>01</sub> : By selecting this option, the Bayes factor will show evidence for the null hypothesis relative to the alternative hypothesis. This is equal to 1/BF<sub>10</sub>.
- Log(BF<sub>10</sub>) : By selecting this option, the natural logarithm of BF<sub>10</sub>, BF<sub>m</sub>, BF<sub>Inclusion</sub>, BF<sub>10, U</sub> will be displayed in the output.



### Output
----------

#### Model Summary
  - Prior: Prior distribution for the alternative hypothesis.
  - BF10: Bayes factor in favor of the alternative hypothesis.



### References
--------------
- Dienes, Z. (2014). Using Bayes to get the most out of non-significant results. Frontiers in Psychology, 5. https://doi.org/10.3389/fpsyg.2014.00781

- Dienes, Z., & Mclatchie, N. (2018). Four reasons to prefer Bayesian analyses over significance testing. Psychonomic Bulletin & Review, 25, 207–218. https://doi.org/10.3758/s13423-017-1266-z


### R packages
--------------
  - bayesplay