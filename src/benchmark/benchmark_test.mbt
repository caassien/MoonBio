///|
test "reference_benchmark_is_deterministic_and_traceable" {
  let report = run_benchmark("ATG").unwrap()
  assert_eq(report.sequence_count, 2)
  assert_true(report.total_bases > 200)
  assert_true(report.total_motif_hits > 0)
  assert_true(report.average_gc_percent > 0)
  assert_true(report.alignment_identity_percent > 90)
  assert_true(report.alignment_cigar.length() > 0)
  assert_eq(report.quality_total_reads, 4)
  assert_eq(report.quality_passed_reads, 3)
}

///|
test "reference_fixture_metadata_contains_public_accessions" {
  let references = reference_sequences()
  assert_eq(references.length(), 2)
  assert_true(references[0].source.contains("NM_000518.5"))
  assert_true(references[1].source.contains("J01636.1"))
  assert_eq(reference_sequence_count(), 2)
  assert_true(total_reference_bases() > 200)
}

///|
test "benchmark_rejects_empty_motifs" {
  assert_eq(run_benchmark("") is Err(_), true)
}
