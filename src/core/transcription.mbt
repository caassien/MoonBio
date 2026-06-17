pub fn transcribe(dna: DnaSequence) -> Array[Nucleotide] {
  let rna = Array::new(capacity=dna.sequence.length())
  for i = 0; i < dna.sequence.length(); i = i + 1 {
    let n = dna.sequence[i]
    if n == T {
      rna.push(U)
    } else {
      rna.push(n)
    }
  }
  rna
}
