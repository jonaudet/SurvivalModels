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
    scale[i] <- x[i] * betas[, 1] + Intercepts[1];
    shape[i] <- exp(x[i] * betas[, 2] + Intercepts[2]);
  }
  
  for(i in 1:N_cens){
    scale_cens[i] <- Predictors_cens[i] * betas[, 1] + Intercepts[1];
    shape_cens[i] <- exp(Predictors_cens[i] * betas[, 2] + Intercepts[2]);
  }
}
model{
  to_vector(betas) ~ normal(0, 1);
  Intercepts ~ normal(0, 10);
  
  // print(scale);
  // print(shape);
  
  time ~ lognormal(scale, shape);
  increment_log_prob(lognormal_ccdf_log(time_cens, scale_cens, shape_cens));
}
generated quantities{
  int mid;
  int end;
  vector[N_obs + N_cens] log_lik;
  
  mid <- N_obs + 1;
  end <- N_obs + N_cens;
  
  for(i in 1:N_obs)
    log_lik[i] <- lognormal_log(time[i], scale[i], shape[i]);
  
  for(i in mid:end)
    log_lik[i] <- lognormal_ccdf_log(time_cens[i - N_obs], scale_cens[i - N_obs], shape_cens[i - N_obs]);
}