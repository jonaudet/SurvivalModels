data{
  int<lower = 1> N_Preds;
  int<lower = 1> N_obs;
  matrix[N_obs, N_Preds] Predictors;
  vector[N_obs] time;
  
  int N_cens;
  matrix[N_cens, N_Preds] Predictors_cens;
  vector<lower = 0>[N_cens] time_cens;
}
parameters{
  matrix[N_Preds, 2] betas;
  vector[2] Intercepts;
  vector<lower = 0>[N_cens] d_cens;
}
transformed parameters{
  vector<lower = 0>[N_cens] time_cens_estimate;
  vector[N_obs] shape;
  vector[N_cens] shape_cens;
  vector<lower = 0>[N_obs] scale;
  vector<lower = 0>[N_cens] scale_cens;
  
  for(i in 1:N_obs){
    shape[i] <- exp(Predictors[i] * betas[, 1] + Intercepts[1]);
    scale[i] <- exp(Predictors[i] * betas[, 2] + Intercepts[2]);
  }
  
  for(i in 1:N_cens){
    shape_cens[i] <- exp(Predictors_cens[i] * betas[, 1] + Intercepts[1]);
    scale_cens[i] <- exp(Predictors_cens[i] * betas[, 2] + Intercepts[2]);
  }

  time_cens_estimate <- time_cens + d_cens;

}
model{
  vector[N_obs] inv_scale;
  vector[N_cens] inv_scale_cens;

  Intercepts ~ normal(4, 2);
  to_vector(betas) ~ normal(0, 1);
  d_cens ~ normal(500, 150);


  for(i in 1:N_obs)
    inv_scale[i] <- 1.0 / scales[i];
    
  for(i in 1:N_cens)
    inv_scale_cens[i] <- 1.0 / scales_cens[i];

  time ~ gamma(shapes, inv_scale);
  time_cens_estimate ~ gamma(shape_cens, inv_scale_cens);
}
