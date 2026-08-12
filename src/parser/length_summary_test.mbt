///|
test "length_summary_exposes_assembly_scale_metrics" {
  let summary = fasta_length_summary(">a\nAA\n>b\nAAAA\n").unwrap()
  assert_eq(summary.record_count, 2)
  assert_eq(summary.total_bases, 6)
  assert_eq(summary.minimum_length, 2)
  assert_eq(summary.maximum_length, 4)
  assert_eq(summary.n50, 4)
}
