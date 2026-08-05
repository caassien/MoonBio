///|
test "parse_fasta_multiline_and_summary" {
  let fasta = ">seq1\nGATTA\nCA\n>seq2\nGGTT\n"
  let records = parse_fasta(fasta).unwrap()
  assert_eq(records.length(), 2)
  assert_eq(records[0].sequence, "GATTACA")
  assert_eq(records[1].sequence, "GGTT")

  let stats = fasta_summary(fasta).unwrap()
  assert_eq(stats.record_count, 2)
  assert_eq(stats.total_bases, 11)
  assert_eq(stats.min_length, 4)
  assert_eq(stats.max_length, 7)
}

///|
test "parse_fastq_and_summary" {
  let fastq = "@read1\nGATTACA\n+\nIIIIIII\n@read2\nGGTT\n+\nHHHH\n"
  let records = parse_fastq(fastq).unwrap()
  assert_eq(records.length(), 2)
  assert_eq(records[0].quality, "IIIIIII")

  let stats = fastq_summary(fastq).unwrap()
  assert_eq(stats.record_count, 2)
  assert_eq(stats.total_bases, 11)
}

///|
test "reject_invalid_fastq_quality_length" {
  let fastq = "@read1\nGATTACA\n+\nIIIIII\n"
  assert_eq(parse_fastq(fastq) is Err(_), true)
}

///|
test "fasta_gc_percent_ignores_ambiguous_bases" {
  let fasta = ">seq1\nGCGTNNAA\n"
  assert_eq(fasta_gc_percent(fasta).unwrap(), 50)
}

///|
test "fastq_quality_range" {
  let fastq = "@read1\nGATT\n+\n!I!I\n@read2\nGGTT\n+\nHHHH\n"
  assert_eq(fastq_quality_range(fastq).unwrap(), [0, 40])
}
