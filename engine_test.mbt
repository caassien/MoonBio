///|
test "bio_engine_end_to_end" {
  let engine = BioEngine::new()
  let global = engine.global_align("GATTACA", "GCATGCU")
  assert_eq(global.score, 0)

  let msa = engine.multiple_align(["GATTACA", "GCATGCU", "GATTATA"])
  assert_eq(msa.aligned_sequences.length(), 3)
  assert_eq(
    msa.aligned_sequences[0].length() == msa.aligned_sequences[1].length(),
    true,
  )
  assert_eq(
    msa.aligned_sequences[1].length() == msa.aligned_sequences[2].length(),
    true,
  )
}
