///|
test "alignment_path_reports_cigar_identity_and_edits" {
  let result = needleman_wunsch("ACGT", "AGT", 2, -1, -2)
  let cigar = alignment_cigar(result.alignment_a, result.alignment_b).unwrap()
  assert_eq(cigar, "1M1D2M")
  assert_eq(
    alignment_identity(result.alignment_a, result.alignment_b).unwrap(),
    75,
  )
  assert_eq(
    alignment_edit_distance(result.alignment_a, result.alignment_b).unwrap(),
    1,
  )
}

///|
test "alignment_path_rejects_malformed_columns" {
  assert_eq(alignment_cigar("A-", "--") is Err(_), true)
  assert_eq(alignment_cigar("AC", "A") is Err(_), true)
  assert_eq(alignment_identity("", "").unwrap(), 0)
}
