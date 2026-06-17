pub fn parse_dna(s: String) -> Result[DnaSequence, String] {
  let seq = Array::new(capacity=s.length())
  for i = 0; i < s.length(); i = i + 1 {
    let c = s[i].to_int().unsafe_to_char()
    if c == 'A' || c == 'a' {
      seq.push(A)
    } else if c == 'C' || c == 'c' {
      seq.push(C)
    } else if c == 'G' || c == 'g' {
      seq.push(G)
    } else if c == 'T' || c == 't' {
      seq.push(T)
    } else {
      return Err("Invalid DNA character: " + c.to_string())
    }
  }
  Ok({ sequence: seq })
}
