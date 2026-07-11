///|
pub struct AlignmentConfig {
  match_score : Int
  mismatch_score : Int
  gap_penalty : Int
} derive(Eq, Debug)

///|
pub fn default_alignment_config() -> AlignmentConfig {
  { match_score: 1, mismatch_score: -1, gap_penalty: -1 }
}
