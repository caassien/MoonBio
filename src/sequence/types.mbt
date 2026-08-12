///|
pub struct BaseCounts {
  a : Int
  c : Int
  g : Int
  t : Int
  ambiguous : Int
  invalid : Int
  total : Int
} derive(Eq, Debug)

///|
pub struct KmerCount {
  kmer : String
  count : Int
} derive(Eq, Debug)

///|
pub struct MotifHit {
  start : Int
  end : Int
  matched : String
} derive(Eq, Debug)

///|
pub struct HomopolymerRun {
  base : String
  start : Int
  length : Int
} derive(Eq, Debug)

///|
pub struct TranslationResult {
  protein : String
  stop_found : Bool
  codons_read : Int
  frame : Int
} derive(Eq, Debug)

///|
pub struct Orf {
  start : Int
  end : Int
  frame : Int
  strand : String
  protein : String
} derive(Eq, Debug)
