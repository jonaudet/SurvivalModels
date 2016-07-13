# SurvivalModels
Various survival models coded in Stan

All models account for censoring. The exponential, lognormal, weibull, and logistic
use the ccdf to do so. For the gamma, the gamma_ccdf function had trouble converging
(asking for very large `max_treedepth`) so the censored data is taken into account
by considering it as missing data (based on a suggestion by Richard McElreath on 
the Stan users mailing list, here: https://groups.google.com/d/msg/stan-users/65nVen9sIsM/o6PP0MiQM9cJ ).

## Models

In all cases the $\beta * Predictors$ assumes a N x P matrix of predictors. 

1.  survival_exponential_cens_Regression.stan:
    * Assume that the hazard function is exponential. The rate of the exponential is
  modeled as: $log(\lambda) = \alpha + \beta * Predictors$. The rate is exponentiated
  before being passed to the sampling function.
  
1.  survival_lnormal_cens_Regression.stan:
    * Assume that the hazard function is lognormal. The location of the lognormal is
  modeled as: $log(\mu) = \alpha + \beta * Predictors$. The scale of the lognormal is
  modeled as: $log(\sigma) = \alpha + \beta * Predictors$. Only the scale is
  exponentiated as Stan expects it to be larger than 0.
  
1.  survival_weibull_cens_Regression.stan:
    * Assume that the hazard function is the weibull distribution. The scale of the weibull is
  modeled as: $log(\alpha) = \alpha + \beta * Predictors$. The shape of the weibull is
  modeled as: $log(\sigma) = \alpha + \beta * Predictors$. Both parameters are exponentiated
  before the sampling function.
  
1.  survival_logistic_cens_Regression.stan:
    * Assume that the hazard function is the logistic distribution. The location of the logistic is
  modeled as: $\mu = \alpha + \beta * Predictors$. The scale of the logistic is
  modeled as: $log(\sigma) = \alpha + \beta * Predictors$. Only the scale is
  exponentiated as Stan expects it to be larger than 0.
  
1.  survival_gamma_2group_cens.stan:
    * Assume that the hazard function is the gamma distribution. The shape and scale of the gamma
    are modeled directly on the constrained (> 0) linear scale. The scale is inverted
    as Stan uses inverse-scale parameterization. The censored observations are modeled as
	missing data with a lower bound at the censoring threshold and unknown (modeled) additional contribution. The model
was designed for mice, so the prior on the missing data assumes survival of 500 units (days for me) with SD 150.
