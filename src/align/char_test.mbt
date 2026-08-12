///|
test "test_char" {
  let s = "GATTACA"
  let c = s[0]
  assert_eq(c.to_int(), 'G'.to_int())
}
