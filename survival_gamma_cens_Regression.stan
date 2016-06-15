data{
  int<lower = 1> N_Preds;
  int<lower = 1> N_obs;
  int x[N_obs];
  vector[N_obs] time;

  int N_cens;
  int Predictors_cens[N_cens];
  vector<lower = 0>[N_cens] time_cens;
}
parameters{
  vector<lower = 0>[2] shapes;
  vector<lower = 0>[2] scales;
  vector<lower = 0>[N_cens] d_cens;
}
transformed parameters{
vector<lower = 0>[N_cens] time_cens_estimate;

time_cens_estimate <- time_cens + d_cens;

}
model{
  vector[2] inv_scale;

  shapes ~ gamma(4, 1.0/ 4);
  scales ~ gamma(2, 1);
  d_cens ~ normal(500, 150);


  for(i in 1:2)
    inv_scale[i] <- 1.0 / scales[i];

  time ~ gamma(shapes[x], inv_scale[x]);
  time_cens_estimate ~ gamma(shapes[Predictors_cens], inv_scale[Predictors_cens]);
}
