///|
test "phred_decoding_and_mean_are_deterministic" {
  let values = phred_values("!5I").unwrap()
  assert_eq(values[0], 0)
  assert_eq(values[1], 20)
  assert_eq(values[2], 40)
  assert_eq(mean_quality("!5I").unwrap(), 20)
}

///|
test "quality_distribution_counts_each_phred_bin" {
  let distribution = quality_distribution("!5I!").unwrap()
  assert_eq(distribution.minimum, 0)
  assert_eq(distribution.maximum, 40)
  assert_eq(distribution.counts[0], 2)
  assert_eq(distribution.counts[20], 1)
  assert_eq(distribution.counts[40], 1)
}

///|
test "low_quality_windows_reports_start_positions" {
  let starts = low_quality_windows("II!!II", 2, 10).unwrap()
  assert_eq(starts.length(), 1)
  assert_eq(starts[0], 2)
}

///|
test "trim_quality_removes_low_quality_ends" {
  let trimmed = trim_quality("ACGTAC", "!!II!!", 20).unwrap()
  assert_eq(trimmed.sequence, "GT")
  assert_eq(trimmed.quality, "II")
  assert_eq(trimmed.left_trim, 2)
  assert_eq(trimmed.right_trim, 2)
}

///|
test "fastq_quality_summary_and_filter" {
  let fastq = "@good\nGATT\n+\nIIII\n@bad\nGGTT\n+\n!!!!\n"
  let summary = fastq_quality_summary(fastq, 20).unwrap()
  assert_eq(summary.read_count, 2)
  assert_eq(summary.passed_reads, 1)
  assert_eq(summary.failed_reads, 1)
  let filtered = filter_fastq(fastq, 4, 20).unwrap()
  assert_eq(filtered.passed_reads, 1)
  assert_eq(filtered.passed_bases, 4)
}

///|
test "quality_edges_reject_bad_thresholds_and_lengths" {
  assert_eq(phred_values("").unwrap().length(), 0)
  assert_eq(mean_quality("") is Err(_), true)
  assert_eq(low_quality_windows("IIII", 0, 20) is Err(_), true)
  assert_eq(trim_quality("AC", "!", 20) is Err(_), true)
}

///|
test "quality_range_handles_empty_and_nonempty_streams" {
  let range = quality_range("!I").unwrap()
  assert_eq(range[0], 0)
  assert_eq(range[1], 40)
}
