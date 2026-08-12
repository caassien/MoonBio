///|
pub fn find_motif(
  sequence : String,
  motif : String,
  allow_ambiguous : Bool,
) -> Result[Array[MotifHit], String] {
  if motif.length() == 0 {
    return Err("motif must not be empty")
  }
  match compact_iupac(sequence) {
    Err(err) => Err(err)
    Ok(subject) =>
      match compact_iupac(motif) {
        Err(err) => Err(err)
        Ok(pattern) => {
          if pattern.length() > subject.length() {
            return Ok([])
          }
          let hits = []
          for i = 0; i <= subject.length() - pattern.length(); i = i + 1 {
            let mut matches = true
            for j = 0; j < pattern.length(); j = j + 1 {
              let expected = pattern[j]
              let observed = subject[i + j]
              if allow_ambiguous {
                if !iupac_matches(expected, observed) {
                  matches = false
                  break
                }
              } else if canonical_dna_code(expected) !=
                canonical_dna_code(observed) {
                matches = false
                break
              }
            }
            if matches {
              hits.push({
                start: i,
                end: i + pattern.length(),
                matched: subject[i:i + pattern.length()].to_owned(),
              })
            }
          }
          Ok(hits)
        }
      }
  }
}

///|
pub fn hamming_distance(left : String, right : String) -> Result[Int, String] {
  match (normalize_dna(left), normalize_dna(right)) {
    (Err(err), _) => Err(err)
    (_, Err(err)) => Err(err)
    (Ok(a), Ok(b)) => {
      if a.length() != b.length() {
        return Err("Hamming distance requires equal sequence lengths")
      }
      let mut distance = 0
      for i = 0; i < a.length(); i = i + 1 {
        if a[i] != b[i] {
          distance = distance + 1
        }
      }
      Ok(distance)
    }
  }
}

///|
pub fn mismatch_positions(
  left : String,
  right : String,
) -> Result[Array[Int], String] {
  match (normalize_dna(left), normalize_dna(right)) {
    (Err(err), _) => Err(err)
    (_, Err(err)) => Err(err)
    (Ok(a), Ok(b)) => {
      if a.length() != b.length() {
        return Err("mismatch profile requires equal sequence lengths")
      }
      let positions = []
      for i = 0; i < a.length(); i = i + 1 {
        if a[i] != b[i] {
          positions.push(i)
        }
      }
      Ok(positions)
    }
  }
}
