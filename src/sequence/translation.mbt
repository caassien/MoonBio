///|
pub fn reverse_complement(sequence : String) -> Result[String, String] {
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let mut result = ""
      if normalized.length() == 0 {
        return Ok(result)
      }
      for i = normalized.length() - 1; i >= 0; i = i - 1 {
        let c = normalized[i]
        let complement = if c == 'A' {
          'T'
        } else if c == 'C' {
          'G'
        } else if c == 'G' {
          'C'
        } else if c == 'T' {
          'A'
        } else {
          'N'
        }
        result = result + complement.to_string()
      }
      Ok(result)
    }
  }
}

///|
pub fn transcribe(sequence : String) -> Result[String, String] {
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let mut rna = ""
      for i = 0; i < normalized.length(); i = i + 1 {
        if normalized[i] == 'T' {
          rna = rna + "U"
        } else {
          rna = rna + code_string(normalized[i])
        }
      }
      Ok(rna)
    }
  }
}

///|
pub fn codon_to_amino(codon : String) -> Result[String, String] {
  if codon.length() != 3 {
    return Err("codon must contain exactly three bases")
  }
  let a = canonical_dna_code(char_at(codon, 0))
  let b = canonical_dna_code(char_at(codon, 1))
  let c = canonical_dna_code(char_at(codon, 2))
  if !is_canonical_code(a) || !is_canonical_code(b) || !is_canonical_code(c) {
    return Err("codon contains an ambiguous base")
  }
  let amino = if a == 'T' {
    if b == 'T' {
      if c == 'T' || c == 'C' {
        "F"
      } else {
        "L"
      }
    } else if b == 'C' {
      "S"
    } else if b == 'A' {
      if c == 'T' || c == 'C' {
        "Y"
      } else if c == 'A' || c == 'G' {
        "*"
      } else {
        "X"
      }
    } else if c == 'A' {
      "*"
    } else if c == 'G' {
      "W"
    } else {
      "C"
    }
  } else if a == 'C' {
    if b == 'T' {
      "L"
    } else if b == 'C' {
      "P"
    } else if b == 'A' {
      if c == 'T' || c == 'C' {
        "H"
      } else {
        "Q"
      }
    } else {
      "R"
    }
  } else if a == 'A' {
    if b == 'T' {
      if c == 'T' || c == 'C' || c == 'A' {
        "I"
      } else {
        "M"
      }
    } else if b == 'C' {
      "T"
    } else if b == 'A' {
      if c == 'T' || c == 'C' {
        "N"
      } else {
        "K"
      }
    } else if b == 'G' {
      if c == 'T' || c == 'C' {
        "S"
      } else {
        "R"
      }
    } else if c == 'T' || c == 'C' || c == 'A' {
      "T"
    } else {
      "M"
    }
  } else if b == 'T' {
    "V"
  } else if b == 'C' {
    "A"
  } else if b == 'A' {
    if c == 'T' || c == 'C' {
      "D"
    } else {
      "E"
    }
  } else {
    "G"
  }
  Ok(amino)
}

///|
pub fn translate(
  sequence : String,
  frame : Int,
) -> Result[TranslationResult, String] {
  if frame < 0 || frame > 2 {
    return Err("translation frame must be 0, 1, or 2")
  }
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let mut protein = ""
      let mut codons_read = 0
      let mut stop_found = false
      let mut position = frame
      while position + 2 < normalized.length() {
        let codon = normalized[position:position + 3].to_owned()
        match codon_to_amino(codon) {
          Err(err) => return Err(err)
          Ok(amino) => {
            protein = protein + amino
            codons_read = codons_read + 1
            position = position + 3
            if amino == "*" {
              stop_found = true
              break
            }
          }
        }
      }
      Ok({ protein, stop_found, codons_read, frame })
    }
  }
}
