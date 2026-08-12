///|
test "validate_iupac_accepts_ambiguous_dna" {
  assert_true(validate_iupac("ACGTRYSWKMBDHVN") is Ok(_))
  assert_eq(validate_iupac("ACGTX") is Err(_), true)
}

///|
test "base_counts_and_gc_percent_ignore_ambiguity" {
  let counts = base_counts("ACGTTNRY").unwrap()
  assert_eq(counts.a, 1)
  assert_eq(counts.c, 1)
  assert_eq(counts.g, 1)
  assert_eq(counts.t, 2)
  assert_eq(counts.ambiguous, 3)
  assert_eq(gc_percent("ACGTTNRY").unwrap(), 40)
}

///|
test "kmer_counts_are_sorted_and_count_overlaps" {
  let counts = kmer_counts("ATATAT", 2).unwrap()
  assert_eq(counts.length(), 2)
  assert_eq(counts[0].kmer, "AT")
  assert_eq(counts[0].count, 3)
  assert_eq(counts[1].kmer, "TA")
  assert_eq(counts[1].count, 2)
}

///|
test "motif_search_uses_iupac_symbols" {
  let hits = find_motif("AAGATGACATG", "ATN", true).unwrap()
  assert_eq(hits.length(), 2)
  assert_eq(hits[0].start, 3)
  assert_eq(hits[1].start, 8)
}

///|
test "hamming_distance_rejects_different_lengths" {
  assert_eq(hamming_distance("ACGT", "ACGA").unwrap(), 1)
  assert_eq(hamming_distance("ACGT", "ACG") is Err(_), true)
}

///|
test "transcription_and_translation_handle_stop" {
  assert_eq(transcribe("ACGT").unwrap(), "ACGU")
  let translated = translate("ATGGCCCTGTAA", 0).unwrap()
  assert_eq(translated.protein, "MAL*")
  assert_eq(translated.stop_found, true)
  assert_eq(translated.codons_read, 4)
}

///|
test "orf_finder_reports_forward_frame" {
  let orfs = find_orfs("CCCATGGCCCTGTAA", 3).unwrap()
  assert_eq(orfs.length(), 1)
  assert_eq(orfs[0].start, 3)
  assert_eq(orfs[0].end, 15)
  assert_eq(orfs[0].protein, "MAL*")
}

///|
test "sequence_edges_are_explicit" {
  assert_eq(kmer_counts("AC", 3) is Err(_), true)
  assert_eq(find_motif("", "A", true).unwrap().length(), 0)
  assert_eq(translate("ATG", 3) is Err(_), true)
}
