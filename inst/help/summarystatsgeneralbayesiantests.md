Summary Statistics General Bayesian Tests
====================================

The general Bayesian tests allows one to test a hypothesis about a parameter under different data likelihoods.


### Input
---------

#### Data
The input data needs to contain the following elements:

- Likelihood specifying the distribution of the data
  - Normal with mean and standard deviation
  - Student-t with mean, standard deviation, and degrees of freedom
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



### R packages
--------------
  - bayesplay