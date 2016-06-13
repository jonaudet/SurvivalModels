data{
  int<lower = 1> N_Preds;
  int<lower = 1> N_obs;
  matrix[N_obs, N_Preds] x;
  vector[N_obs] time;
  
  int N_cens;
  matrix[N_cens, N_Preds] Predictors_cens;
  vector<lower = 0>[N_cens] time_cens;
}
parameters{
  vector[N_Preds] betas;
  real Intercepts;
}
transformed parameters{
  vector[N_obs] loc;
  vector[N_cens] loc_cens;
  
  for(i in 1:N_obs){
    loc[i] <- exp(x[i] * betas + Intercepts);
  }
  
  for(i in 1:N_cens){
    loc_cens[i] <- exp(Predictors_cens[i] * betas + Intercepts);
  }
}
model{
  betas ~ normal(0, 1);
  Intercepts ~ normal(0, 10);
  
  // print(scale);
  // print(shape);
  
  time ~ exponential(loc);
  increment_log_prob(exponential_ccdf_log(time_cens, loc_cens));
}
