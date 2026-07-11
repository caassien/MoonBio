///|
test "validate_dna_string_and_records" {
  assert_eq(validate_dna_string("GATTACA") is Err(_), false)
  assert_eq(validate_non_empty_records(1, "FASTA") is Err(_), false)
  assert_eq(validate_dna_string("XYZ") is Err(_), true)
}
