pub(all) struct HMM {
  states: Array[String]
  observations: Array[String]
  start_prob: Array[Double]
  trans_prob: Array[Array[Double]]
  emit_prob: Array[Array[Double]]
}

/// Viterbi decoding algorithm to find the most likely sequence of hidden states.
pub fn viterbi(model: HMM, obs_seq: Array[Int]) -> Array[String] {
  let n_states = model.states.length()
  let t_len = obs_seq.length()
  
  if t_len == 0 {
    return []
  }

  // v[t][j] stores the probability of the most likely path to state j at time t
  let v = Array::make(t_len, [])
  for i = 0; i < t_len; i = i + 1 {
    v[i] = Array::make(n_states, 0.0)
  }
  
  // path[t][j] stores the state index at time t-1 that maximizes the probability for state j at time t
  let path = Array::make(t_len, [])
  for i = 0; i < t_len; i = i + 1 {
    path[i] = Array::make(n_states, 0)
  }

  // Initialization
  let first_obs = obs_seq[0]
  for s = 0; s < n_states; s = s + 1 {
    v[0][s] = model.start_prob[s] * model.emit_prob[s][first_obs]
    path[0][s] = s
  }

  // Recursion
  for t = 1; t < t_len; t = t + 1 {
    let obs = obs_seq[t]
    for j = 0; j < n_states; j = j + 1 {
      let mut max_p = -1.0
      let mut max_s = 0
      for i = 0; i < n_states; i = i + 1 {
        let p = v[t - 1][i] * model.trans_prob[i][j] * model.emit_prob[j][obs]
        if p > max_p {
          max_p = p
          max_s = i
        }
      }
      v[t][j] = max_p
      path[t][j] = max_s
    }
  }

  // Termination
  let mut max_p = -1.0
  let mut last_state = 0
  for s = 0; s < n_states; s = s + 1 {
    if v[t_len - 1][s] > max_p {
      max_p = v[t_len - 1][s]
      last_state = s
    }
  }

  // Backtracking
  let best_path = Array::make(t_len, 0)
  best_path[t_len - 1] = last_state
  for t = t_len - 1; t > 0; t = t - 1 {
    best_path[t - 1] = path[t][best_path[t]]
  }

  let result = Array::make(t_len, "")
  for t = 0; t < t_len; t = t + 1 {
    result[t] = model.states[best_path[t]]
  }
  
  result
}
