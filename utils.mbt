///|
pub fn normalize_sequence(sequence : String) -> String {
  let mut normalized = ""
  for i = 0; i < sequence.length(); i = i + 1 {
    let c = sequence[i]
    if c == ' ' || c == '\t' || c == '\n' || c == '\r' {
      continue
    }
    if c == 'a' {
      normalized = normalized + "A"
    } else if c == 'c' {
      normalized = normalized + "C"
    } else if c == 'g' {
      normalized = normalized + "G"
    } else if c == 't' {
      normalized = normalized + "T"
    } else if c == 'u' {
      normalized = normalized + "U"
    } else {
      normalized = normalized + c.to_int().unsafe_to_char().to_string()
    }
  }
  normalized
}

///|
pub fn gc_ratio_percent(sequence : String) -> Int {
  let normalized = normalize_sequence(sequence)
  if normalized.length() == 0 {
    return 0
  }

  let mut gc = 0
  for i = 0; i < normalized.length(); i = i + 1 {
    let c = normalized[i]
    if c == 'G' || c == 'C' {
      gc = gc + 1
    }
  }
  gc * 100 / normalized.length()
}
