///|
test "consensus_and_identity_matrix_handle_ambiguous_columns" {
  let consensus = consensus_sequence(["ACGT", "ACGA", "ACGN"], 2).unwrap()
  assert_eq(consensus, "ACGN")
  let matrix = pairwise_identity_matrix(["ACGT", "ACGA", "TTTT"]).unwrap()
  assert_eq(matrix.length(), 3)
  assert_eq(matrix[0][0], 100)
  assert_eq(matrix[0][1], 75)
  assert_eq(matrix[0][2], 25)
}

///|
test "consensus_validates_inputs_and_motif_density_is_scaled" {
  assert_eq(consensus_sequence([], 2).unwrap(), "")
  assert_eq(consensus_sequence(["AC", "A"], 1) is Err(_), true)
  assert_eq(motif_density("ATATAT", "AT").unwrap(), 50)
  assert_eq(motif_density("ACGT", "") is Err(_), true)
}
