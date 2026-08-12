///|
pub fn sequence_length(sequence : String) -> Result[Int, String] {
  match compact_iupac(sequence) {
    Err(err) => Err(err)
    Ok(compact) => Ok(compact.length())
  }
}

///|
pub fn base_counts(sequence : String) -> Result[BaseCounts, String] {
  match compact_iupac(sequence) {
    Err(err) => Err(err)
    Ok(compact) => {
      let mut a = 0
      let mut c = 0
      let mut g = 0
      let mut t = 0
      let mut ambiguous = 0
      for i = 0; i < compact.length(); i = i + 1 {
        let code = canonical_dna_code(compact[i])
        if code == 'A' {
          a = a + 1
        } else if code == 'C' {
          c = c + 1
        } else if code == 'G' {
          g = g + 1
        } else if code == 'T' {
          t = t + 1
        } else {
          ambiguous = ambiguous + 1
        }
      }
      Ok({ a, c, g, t, ambiguous, invalid: 0, total: compact.length() })
    }
  }
}

///|
pub fn gc_percent(sequence : String) -> Result[Int, String] {
  match base_counts(sequence) {
    Err(err) => Err(err)
    Ok(counts) => {
      let canonical = counts.a + counts.c + counts.g + counts.t
      if canonical == 0 {
        Ok(0)
      } else {
        Ok((counts.c + counts.g) * 100 / canonical)
      }
    }
  }
}

///|
pub fn at_percent(sequence : String) -> Result[Int, String] {
  match base_counts(sequence) {
    Err(err) => Err(err)
    Ok(counts) => {
      let canonical = counts.a + counts.c + counts.g + counts.t
      if canonical == 0 {
        Ok(0)
      } else {
        Ok((counts.a + counts.t) * 100 / canonical)
      }
    }
  }
}

///|
pub fn ambiguous_percent(sequence : String) -> Result[Int, String] {
  match base_counts(sequence) {
    Err(err) => Err(err)
    Ok(counts) =>
      if counts.total == 0 {
        Ok(0)
      } else {
        Ok(counts.ambiguous * 100 / counts.total)
      }
  }
}

///|
pub fn homopolymer_runs(
  sequence : String,
  minimum_length : Int,
) -> Result[Array[HomopolymerRun], String] {
  if minimum_length < 1 {
    return Err("minimum homopolymer length must be positive")
  }
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let runs = []
      if normalized.length() == 0 {
        return Ok(runs)
      }
      let mut start = 0
      let mut i = 1
      while i <= normalized.length() {
        if i == normalized.length() || normalized[i] != normalized[start] {
          let length = i - start
          if length >= minimum_length {
            runs.push({ base: code_string(normalized[start]), start, length })
          }
          start = i
        }
        i = i + 1
      }
      Ok(runs)
    }
  }
}

///|
pub fn has_only_canonical_bases(sequence : String) -> Result[Bool, String] {
  match base_counts(sequence) {
    Err(err) => Err(err)
    Ok(counts) => Ok(counts.ambiguous == 0)
  }
}
