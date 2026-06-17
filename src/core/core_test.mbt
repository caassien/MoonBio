test "parser_and_transcription" {
  let dna = parse_dna("GATTACA").unwrap()
  let rna = transcribe(dna)
  assert_eq(rna.length(), 7)
  assert_eq(rna[2] == Nucleotide::U, true)
  
  let rc = reverse_complement(dna)
  assert_eq(rc.sequence[0] == Nucleotide::T, true)
  assert_eq(rc.sequence[1] == Nucleotide::G, true)
}
