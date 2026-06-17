pub(all) enum Nucleotide {
  A
  C
  G
  T
  U
} derive(Eq, Debug)

pub(all) struct DnaSequence {
  sequence: Array[Nucleotide]
}
