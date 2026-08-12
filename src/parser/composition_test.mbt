///|
test "sequence_symbol_summary_counts_unknown_and_n_bases" {
  let fasta = ">a\nACGTNNX\n"
  let summary = fasta_symbol_summary(fasta).unwrap()
  assert_eq(summary.a, 1)
  assert_eq(summary.c, 1)
  assert_eq(summary.g, 1)
  assert_eq(summary.t, 1)
  assert_eq(summary.n, 2)
  assert_eq(summary.other, 1)
  assert_eq(fasta_n_fraction(fasta).unwrap(), 28)
}

///|
test "fastq_symbol_summary_aggregates_reads" {
  let fastq = "@a\nACNN\n+\nIIII\n@b\nTTGG\n+\nIIII\n"
  let summary = fastq_symbol_summary(fastq).unwrap()
  assert_eq(summary.n, 2)
  assert_eq(summary.total, 8)
  assert_eq(fastq_n_fraction(fastq).unwrap(), 25)
}
