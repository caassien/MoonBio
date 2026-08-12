///|
test "per_read_quality_report_preserves_ids_and_decisions" {
  let fastq = "@good\nACGT\n+\nIIII\n@bad\nACGT\n+\n!!!!\n"
  let report = per_read_quality_report(fastq, 20).unwrap()
  assert_eq(report.length(), 2)
  assert_eq(report[0].id, "good")
  assert_eq(report[0].mean_quality, 40)
  assert_eq(report[0].passed, true)
  assert_eq(report[1].passed, false)
}

///|
test "read_pass_mask_matches_report_order" {
  let fastq = "@a\nAC\n+\nII\n@b\nAC\n+\n!!\n"
  let mask = read_pass_mask(fastq, 20).unwrap()
  assert_eq(mask[0], true)
  assert_eq(mask[1], false)
}
