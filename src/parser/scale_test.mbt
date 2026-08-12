///|
test "fasta_n50_and_duplicate_id_checks" {
  let fasta = ">a\nA\n>b\nAAAA\n>c\nAAAAAA\n"
  assert_eq(fasta_n50(fasta).unwrap(), 6)
  assert_eq(validate_unique_fasta_ids(fasta).unwrap(), ())
  let duplicate = ">a\nA\n>a\nAA\n"
  assert_eq(validate_unique_fasta_ids(duplicate) is Err(_), true)
}

///|
test "fastq_length_histogram_is_compact_and_deterministic" {
  let fastq = "@a\nAC\n+\nII\n@b\nACGT\n+\nIIII\n@c\nA\n+\nI\n"
  let histogram = fastq_length_histogram(fastq).unwrap()
  assert_eq(histogram.length(), 5)
  assert_eq(histogram[1], 1)
  assert_eq(histogram[2], 1)
  assert_eq(histogram[4], 1)
}
