data{
  int<lower = 1> N_obs;
  vector[N_obs] time;

  int N_cens;
  vector<lower = 0>[N_cens] time_cens;

  int groups[N_obs + N_cens];
}
parameters{
  vector[2] logit_props;
  ordered[2] log_scales;
  ordered[2] log_shapes;
  vector<lower = 0>[N_cens] d_cens;
}
transformed parameters{
  vector<lower = 0>[N_cens] time_cens_estimate;
  vector[N_obs + N_cens] time_all;
  vector[2] props;

  time_cens_estimate <- time_cens + d_cens;

  time_all <- append_row(time, time_cens_estimate);

    for(i in 1:2)
    props[i] <- inv_logit(logit_props[i]);

}
model{
  vector[2] inv_scale;
  // real ps[2];
  vector[2] shapes;

  log_shapes ~ normal(2, 1);
  log_scales ~ normal(4, 2);
  d_cens ~ normal(500, 150);
  logit_props ~ normal(0, 2.5);

  shapes <- exp(log_shapes);



  for(i in 1:2)
    inv_scale[i] <- 1.0 / exp(log_scales[i]);

  for(i in 1:(N_obs + N_cens)){
    // for(k in 1:2){
    //   ps[k] <- log(thetas[groups[i], k]) + gamma_log(time_all[i], shapes[k], inv_scale[k]);
    //   // ps[k] <- log(thetas[ k]) + gamma_log(time_all[i], shapes[k], inv_scale[k]);
    // }
    // increment_log_prob(log_sum_exp(ps));
    increment_log_prob(log_mix(props[groups[i]], gamma_log(time_all[i], shapes[1], inv_scale[1]), gamma_log(time_all[i], shapes[2], inv_scale[2])));
  }
}
