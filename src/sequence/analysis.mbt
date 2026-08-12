///|
pub struct WindowStatistic {
  start : Int
  end : Int
  gc_percent : Int
  canonical_bases : Int
  ambiguous_bases : Int
  unique_kmers : Int
} derive(Eq, Debug)

///|
pub struct MutationProfile {
  matches : Int
  mismatches : Int
  transitions : Int
  transversions : Int
  ambiguous : Int
} derive(Eq, Debug)

///|
pub fn canonical_positions(
  sequence : String,
  base : Char,
) -> Result[Array[Int], String] {
  let requested = base.to_string()
  let target_text = if base == 'u' || base == 'U' {
    "T"
  } else if base == 'a' || base == 'A' {
    "A"
  } else if base == 'c' || base == 'C' {
    "C"
  } else if base == 'g' || base == 'G' {
    "G"
  } else if base == 't' || base == 'T' {
    "T"
  } else {
    requested
  }
  if target_text != "A" &&
    target_text != "C" &&
    target_text != "G" &&
    target_text != "T" {
    return Err("canonical position query must be A, C, G, or T")
  }
  let target = target_text[0]
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let positions = []
      for i = 0; i < normalized.length(); i = i + 1 {
        if normalized[i] == target {
          positions.push(i)
        }
      }
      Ok(positions)
    }
  }
}

///|
pub fn unique_kmer_count(sequence : String, k : Int) -> Result[Int, String] {
  match kmer_counts(sequence, k) {
    Err(err) => Err(err)
    Ok(counts) => Ok(counts.length())
  }
}

///|
pub fn gc_windows(
  sequence : String,
  window : Int,
  step : Int,
) -> Result[Array[WindowStatistic], String] {
  if window < 1 {
    return Err("GC window must be positive")
  }
  if step < 1 {
    return Err("GC window step must be positive")
  }
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      if window > normalized.length() {
        return Ok([])
      }
      let stats = []
      let k = if window < 2 { 1 } else { 2 }
      let mut start = 0
      while start + window <= normalized.length() {
        let fragment = normalized[start:start + window].to_owned()
        let counts = base_counts(fragment).unwrap()
        let gc = gc_percent(fragment).unwrap()
        let unique = unique_kmer_count(fragment, k).unwrap()
        stats.push({
          start,
          end: start + window,
          gc_percent: gc,
          canonical_bases: counts.a + counts.c + counts.g + counts.t,
          ambiguous_bases: counts.ambiguous,
          unique_kmers: unique,
        })
        start = start + step
      }
      Ok(stats)
    }
  }
}

///|
fn is_canonical_base(c : UInt16) -> Bool {
  c == 'A' || c == 'C' || c == 'G' || c == 'T'
}

///|
fn is_transition(left : UInt16, right : UInt16) -> Bool {
  (left == 'A' && right == 'G') ||
  (left == 'G' && right == 'A') ||
  (left == 'C' && right == 'T') ||
  (left == 'T' && right == 'C')
}

///|
pub fn mutation_profile(
  left : String,
  right : String,
) -> Result[MutationProfile, String] {
  match (normalize_dna(left), normalize_dna(right)) {
    (Err(err), _) => Err(err)
    (_, Err(err)) => Err(err)
    (Ok(a), Ok(b)) => {
      if a.length() != b.length() {
        return Err("mutation profile requires equal sequence lengths")
      }
      let mut matches = 0
      let mut mismatches = 0
      let mut transitions = 0
      let mut transversions = 0
      let mut ambiguous = 0
      for i = 0; i < a.length(); i = i + 1 {
        let left_base = a[i]
        let right_base = b[i]
        if !is_canonical_base(left_base) || !is_canonical_base(right_base) {
          ambiguous = ambiguous + 1
        } else if left_base == right_base {
          matches = matches + 1
        } else {
          mismatches = mismatches + 1
          if is_transition(left_base, right_base) {
            transitions = transitions + 1
          } else {
            transversions = transversions + 1
          }
        }
      }
      Ok({ matches, mismatches, transitions, transversions, ambiguous })
    }
  }
}

///|
pub fn mask_low_complexity(
  sequence : String,
  window : Int,
  maximum_unique_kmers : Int,
) -> Result[String, String] {
  if window < 2 {
    return Err("low-complexity window must be at least two bases")
  }
  if maximum_unique_kmers < 1 {
    return Err("maximum unique k-mer count must be positive")
  }
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      if window > normalized.length() {
        return Ok(normalized)
      }
      let masked = Array::make(normalized.length(), false)
      let mut start = 0
      while start + window <= normalized.length() {
        let fragment = normalized[start:start + window].to_owned()
        let unique = unique_kmer_count(fragment, 2).unwrap()
        if unique <= maximum_unique_kmers {
          for i = start; i < start + window; i = i + 1 {
            masked[i] = true
          }
        }
        start = start + 1
      }
      let mut output = ""
      for i = 0; i < normalized.length(); i = i + 1 {
        let symbol = if masked[i] { "N" } else { code_string(normalized[i]) }
        output = output + symbol
      }
      Ok(output)
    }
  }
}
