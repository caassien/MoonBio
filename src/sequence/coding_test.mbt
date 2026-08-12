///|
test "coding_report_and_all_frames_are_consistent" {
  let report = coding_report("ATGGCCGACTAA", 0).unwrap()
  assert_eq(report.codons_read, 4)
  assert_eq(report.start_codons, 1)
  assert_eq(report.stop_codons, 1)
  assert_eq(report.protein, "MAD*")
  let frames = translate_all_frames("ATGGCCGACTAA").unwrap()
  assert_eq(frames.length(), 3)
  assert_eq(frames[0].protein, "MAD*")
}

///|
test "codon_usage_and_minimizer_sketch_are_reproducible" {
  let usage = codon_usage("ATGGCCGCC", 0).unwrap()
  assert_eq(usage.length(), 2)
  assert_eq(usage[0].count, 1)
  assert_eq(usage[1].count, 2)
  let sketch = minimizer_sketch("ACGTACGT", 3, 4).unwrap()
  assert_true(sketch.length() > 0)
  assert_eq(sequence_complexity("AAAAAA", 2).unwrap(), 20)
}

///|
test "coding_and_sketch_edges_are_rejected" {
  assert_eq(coding_report("ATG", 3) is Err(_), true)
  assert_eq(codon_usage("ATG", -1) is Err(_), true)
  assert_eq(minimizer_sketch("ACGT", 0, 2) is Err(_), true)
}
