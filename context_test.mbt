///|
test "sequence_context" {
  let context = SequenceContext::new("seq-1", "GCGTAA")
  assert_eq(context.id, "seq-1")
  assert_eq(context.length, 6)
  assert_eq(context.gc_percent, 50)
}
