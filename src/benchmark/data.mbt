///|
pub struct BenchmarkSequence {
  name : String
  sequence : String
  source : String
} derive(Eq, Debug)

///|
pub fn reference_sequences() -> Array[BenchmarkSequence] {
  [
    {
      name: "HBB_NM_000518.5_window_1_140",
      sequence: "ACATTTGCTTCTGACACAACTGTGTTCACTAGCAACCTCAAACAGACACCATGGTGCATCTGACTCCTGAGGAGAAGTCTGCCGTTACTGCCCTGTGGGGCAAGGTGAACGTGGATGAAGTTGGTGGTGAGGCCCTGGGC",
      source: "NCBI RefSeq NM_000518.5, bases 1-140",
    },
    {
      name: "lacZ_J01636.1_window_1_140",
      sequence: "GACACCATCGAATGGCGCAAAACCTTTCGCGGTATGGCATGATAGCGCCCGGAAGAGAGTCAATTCAGGGTGGTGAATGTGAAACCAGTAACGTTATACGATGTCGCAGAGTATGCCGGTGTCTCTTATCAGACCGTTTC",
      source: "NCBI GenBank J01636.1, bases 1-140",
    },
  ]
}

///|
pub fn reference_fastq() -> String {
  "@hbb_ref\nACATTTGCTTCT\n+\nIIIIIIIIIIII\n@hbb_variant\nACATTTGCTCGT\n+\nIIIIIIIIIIII\n@lacZ_ref\nGACACCATCGAAT\n+\nIIIIIIIIIIIII\n@low_quality\nGACACCATCGAAT\n+\n!!!!!!!!!!!!!\n"
}

///|
pub fn reference_sequence_count() -> Int {
  reference_sequences().length()
}

///|
pub fn total_reference_bases() -> Int {
  let mut total = 0
  for record in reference_sequences() {
    total = total + record.sequence.length()
  }
  total
}
