///|
test "alignment_summary_counts_columns_and_coordinates" {
  let summary = summarize_alignment("AC-GT", "ATG-T").unwrap()
  assert_eq(summary.columns, 5)
  assert_eq(summary.matches, 2)
  assert_eq(summary.mismatches, 1)
  assert_eq(summary.insertions, 1)
  assert_eq(summary.deletions, 1)
  assert_eq(summary.identity_percent, 40)
  let coordinates = aligned_reference_coordinates("AC-GT", 10).unwrap()
  assert_eq(coordinates[0], 10)
  assert_eq(coordinates[1], 11)
  assert_eq(coordinates[2], -1)
  assert_eq(coordinates[3], 12)
  assert_eq(coordinates[4], 13)
}

///|
test "alignment_scoring_reconstructs_simple_score" {
  let score = score_alignment("ACGT", "AG-T", 2, -1, -2).unwrap()
  assert_eq(score, 1)
  assert_eq(validate_alignment("A-", "--") is Err(_), true)
}

///|
test "alignment_summary_rejects_unequal_lengths" {
  assert_eq(summarize_alignment("AC", "A") is Err(_), true)
  assert_eq(aligned_reference_coordinates("", 4).unwrap().length(), 0)
}
