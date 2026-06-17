test "levenshtein" {
  let d1 = levenshtein_distance("ATCGATCG", "ATCGTTCG")
  assert_eq(d1, 1)
  
  let d2 = levenshtein_distance("GACCGTGC", "GACGGTCG")
  assert_eq(d2, 3)
}

test "needleman_wunsch" {
  let res = needleman_wunsch("GATTACA", "GCATGCU", 1, -1, -1)
  assert_eq(res.score, 0)
  assert_eq(res.alignment_a, "G-ATTACA")
  assert_eq(res.alignment_b, "GCA-TGCU")
}

test "smith_waterman" {
  let res = smith_waterman("TGTTACGG", "GGTTGACTA", 3, -3, -2)
  assert_eq(res.score, 13)
  assert_eq(res.alignment_a, "GTT-AC")
  assert_eq(res.alignment_b, "GTTGAC")
}
