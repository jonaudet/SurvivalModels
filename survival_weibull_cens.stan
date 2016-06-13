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
  matrix[N_Preds, 2] betas;
  vector[2] Intercepts;
}
transformed parameters{
  vector[N_obs] shape;
  vector[N_cens] shape_cens;
  vector<lower = 0>[N_obs] scale;
  vector<lower = 0>[N_cens] scale_cens;
  
  for(i in 1:N_obs){
    shape[i] <- exp(x[i] * betas[, 1] + Intercepts[1]);
    scale[i] <- exp(x[i] * betas[, 2] + Intercepts[2]);
  }
  
  for(i in 1:N_cens){
    shape_cens[i] <- exp(Predictors_cens[i] * betas[, 1] + Intercepts[1]);
    scale_cens[i] <- exp(Predictors_cens[i] * betas[, 2] + Intercepts[2]);
  }
}
model{
  to_vector(betas) ~ normal(0, 1);
  Intercepts ~ normal(0, 10);
  
  // print(scale);
  // print(shape);
  
  time ~ weibull(shape, scale);
  increment_log_prob(weibull_ccdf_log(time_cens, shape_cens, scale_cens));
}