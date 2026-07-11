///|
pub struct SequenceContext {
  id : String
  sequence : String
  length : Int
  gc_percent : Int
} derive(Eq, Debug)

///|
pub fn SequenceContext::new(id : String, sequence : String) -> SequenceContext {
  {
    id,
    sequence,
    length: sequence.length(),
    gc_percent: gc_ratio_percent(sequence),
  }
}
