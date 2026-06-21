test "viterbi_decoding" {
  let hmm = HMM::{
    states: ["Healthy", "Fever"],
    observations: ["Normal", "Cold", "Dizzy"],
    start_prob: [0.6, 0.4],
    trans_prob: [[0.7, 0.3], [0.4, 0.6]],
    emit_prob: [[0.5, 0.4, 0.1], [0.1, 0.3, 0.6]]
  }

  // sequence of observations: Normal(0), Cold(1), Dizzy(2)
  let obs_seq = [0, 1, 2]
  let result = viterbi(hmm, obs_seq)
  
  if result.length() != 3 {
    abort("Length mismatch")
  }
}
