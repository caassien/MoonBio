///|
fn upper(c : UInt16) -> UInt16 {
  if c >= 'a' && c <= 'z' {
    c - ('a' - 'A')
  } else {
    c
  }
}

///|
fn char_at(text : String, index : Int) -> UInt16 {
  upper(text[index])
}

///|
fn is_whitespace(c : UInt16) -> Bool {
  c == ' ' || c == '\n' || c == '\r' || c == '\t'
}

///|
fn is_iupac_code(c : UInt16) -> Bool {
  c == 'A' ||
  c == 'C' ||
  c == 'G' ||
  c == 'T' ||
  c == 'U' ||
  c == 'R' ||
  c == 'Y' ||
  c == 'S' ||
  c == 'W' ||
  c == 'K' ||
  c == 'M' ||
  c == 'B' ||
  c == 'D' ||
  c == 'H' ||
  c == 'V' ||
  c == 'N'
}

///|
fn is_canonical_code(c : UInt16) -> Bool {
  c == 'A' || c == 'C' || c == 'G' || c == 'T' || c == 'U'
}

///|
fn code_string(c : UInt16) -> String {
  c.to_int().unsafe_to_char().to_string()
}

///|
fn canonical_dna_code(c : UInt16) -> UInt16 {
  if c == 'U' {
    'T'
  } else {
    c
  }
}

///|
pub fn validate_iupac(sequence : String) -> Result[Unit, String] {
  for i = 0; i < sequence.length(); i = i + 1 {
    let c = char_at(sequence, i)
    if !is_whitespace(c) && !is_iupac_code(c) {
      return Err("invalid IUPAC base at position {i}: {code_string(c)}")
    }
  }
  Ok(())
}

///|
pub fn validate_dna(sequence : String) -> Result[Unit, String] {
  for i = 0; i < sequence.length(); i = i + 1 {
    let c = char_at(sequence, i)
    if !is_whitespace(c) && !is_canonical_code(c) && c != 'N' {
      return Err("invalid DNA base at position {i}: {code_string(c)}")
    }
  }
  Ok(())
}

///|
pub fn normalize_dna(sequence : String) -> Result[String, String] {
  match validate_dna(sequence) {
    Err(err) => Err(err)
    Ok(_) => {
      let mut normalized = ""
      for i = 0; i < sequence.length(); i = i + 1 {
        let c = char_at(sequence, i)
        if !is_whitespace(c) {
          normalized = normalized + code_string(canonical_dna_code(c))
        }
      }
      Ok(normalized)
    }
  }
}

///|
fn compact_iupac(sequence : String) -> Result[String, String] {
  match validate_iupac(sequence) {
    Err(err) => Err(err)
    Ok(_) => {
      let mut compact = ""
      for i = 0; i < sequence.length(); i = i + 1 {
        let c = char_at(sequence, i)
        if !is_whitespace(c) {
          compact = compact + code_string(canonical_dna_code(c))
        }
      }
      Ok(compact)
    }
  }
}

///|
fn iupac_matches(pattern : UInt16, observed : UInt16) -> Bool {
  let p = canonical_dna_code(pattern)
  let o = canonical_dna_code(observed)
  if p == 'N' {
    is_canonical_code(o)
  } else if p == 'R' {
    o == 'A' || o == 'G'
  } else if p == 'Y' {
    o == 'C' || o == 'T'
  } else if p == 'S' {
    o == 'G' || o == 'C'
  } else if p == 'W' {
    o == 'A' || o == 'T'
  } else if p == 'K' {
    o == 'G' || o == 'T'
  } else if p == 'M' {
    o == 'A' || o == 'C'
  } else if p == 'B' {
    o == 'C' || o == 'G' || o == 'T'
  } else if p == 'D' {
    o == 'A' || o == 'G' || o == 'T'
  } else if p == 'H' {
    o == 'A' || o == 'C' || o == 'T'
  } else if p == 'V' {
    o == 'A' || o == 'C' || o == 'G'
  } else {
    p == o
  }
}
