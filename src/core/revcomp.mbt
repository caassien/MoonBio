pub fn reverse_complement(dna: DnaSequence) -> DnaSequence {
  let len = dna.sequence.length()
  let rev = Array::new(capacity=len)
  for i = len - 1; i >= 0; i = i - 1 {
    let n = dna.sequence[i]
    let comp = if n == A { T } else if n == T { A } else if n == C { G } else if n == G { C } else { n }
    rev.push(comp)
  }
  { sequence: rev }
}
