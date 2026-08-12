///|
test "sequence_window_statistics_and_positions" {
  let windows = gc_windows("ACGTNNGG", 4, 2).unwrap()
  assert_eq(windows.length(), 3)
  assert_eq(windows[0].gc_percent, 50)
  assert_eq(windows[1].ambiguous_bases, 2)
  let positions = canonical_positions("AaCGTN", 'A').unwrap()
  assert_eq(positions.length(), 2)
  assert_eq(positions[0], 0)
  assert_eq(positions[1], 1)
  assert_eq(unique_kmer_count("AAAAACCCCC", 2).unwrap(), 3)
}

///|
test "mutation_profile_separates_transitions_and_transversions" {
  let profile = mutation_profile("ACGTN", "GCGGA").unwrap()
  assert_eq(profile.matches, 2)
  assert_eq(profile.mismatches, 2)
  assert_eq(profile.transitions, 1)
  assert_eq(profile.transversions, 1)
  assert_eq(profile.ambiguous, 1)
}

///|
test "low_complexity_mask_is_deterministic" {
  let masked = mask_low_complexity("AAAAACGT", 4, 1).unwrap()
  assert_eq(masked, "NNNNNCGT")
  assert_eq(gc_windows("ACGT", 0, 1) is Err(_), true)
}
