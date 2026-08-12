///|
fn consensus_base(counts : Array[Int], minimum_support : Int) -> String {
  let mut best = 0
  let mut best_count = counts[0]
  for i = 1; i < 4; i = i + 1 {
    if counts[i] > best_count {
      best = i
      best_count = counts[i]
    }
  }
  if best_count < minimum_support {
    "N"
  } else if best == 0 {
    "A"
  } else if best == 1 {
    "C"
  } else if best == 2 {
    "G"
  } else {
    "T"
  }
}

///|
pub fn consensus_sequence(
  sequences : Array[String],
  minimum_support : Int,
) -> Result[String, String] {
  if minimum_support < 1 {
    return Err("consensus support must be positive")
  }
  if sequences.length() == 0 {
    return Ok("")
  }
  let normalized : Array[String] = []
  let width = match normalize_dna(sequences[0]) {
    Err(err) => return Err(err)
    Ok(value) => {
      normalized.push(value)
      value.length()
    }
  }
  for i = 1; i < sequences.length(); i = i + 1 {
    match normalize_dna(sequences[i]) {
      Err(err) => return Err(err)
      Ok(value) => {
        if value.length() != width {
          return Err("consensus sequences must have equal lengths")
        }
        normalized.push(value)
      }
    }
  }
  let mut output = ""
  for column = 0; column < width; column = column + 1 {
    let counts = [0, 0, 0, 0]
    for sequence in normalized {
      let base = sequence[column]
      if base == 'A' {
        counts[0] = counts[0] + 1
      } else if base == 'C' {
        counts[1] = counts[1] + 1
      } else if base == 'G' {
        counts[2] = counts[2] + 1
      } else if base == 'T' {
        counts[3] = counts[3] + 1
      }
    }
    output = output + consensus_base(counts, minimum_support)
  }
  Ok(output)
}

///|
pub fn pairwise_identity_matrix(
  sequences : Array[String],
) -> Result[Array[Array[Int]], String] {
  let normalized : Array[String] = []
  if sequences.length() == 0 {
    return Ok([])
  }
  let width = match normalize_dna(sequences[0]) {
    Err(err) => return Err(err)
    Ok(value) => {
      normalized.push(value)
      value.length()
    }
  }
  for i = 1; i < sequences.length(); i = i + 1 {
    match normalize_dna(sequences[i]) {
      Err(err) => return Err(err)
      Ok(value) => {
        if value.length() != width {
          return Err("identity matrix sequences must have equal lengths")
        }
        normalized.push(value)
      }
    }
  }
  let matrix : Array[Array[Int]] = []
  for left in normalized {
    let row : Array[Int] = []
    for right in normalized {
      let matches = hamming_distance(left, right).unwrap()
      let identity = if width == 0 {
        0
      } else {
        (width - matches) * 100 / width
      }
      row.push(identity)
    }
    matrix.push(row)
  }
  Ok(matrix)
}

///|
pub fn motif_density(sequence : String, motif : String) -> Result[Int, String] {
  match find_motif(sequence, motif, true) {
    Err(err) => Err(err)
    Ok(hits) =>
      match normalize_dna(sequence) {
        Err(err) => Err(err)
        Ok(normalized) =>
          if normalized.length() == 0 {
            Ok(0)
          } else {
            Ok(hits.length() * 100 / normalized.length())
          }
      }
  }
}

///|
pub fn reverse_complement_many(
  sequences : Array[String],
) -> Result[Array[String], String] {
  let output : Array[String] = []
  for sequence in sequences {
    match reverse_complement(sequence) {
      Err(err) => return Err(err)
      Ok(value) => output.push(value)
    }
  }
  Ok(output)
}

///|
pub fn gc_distance(left : String, right : String) -> Result[Int, String] {
  match (gc_percent(left), gc_percent(right)) {
    (Err(err), _) => Err(err)
    (_, Err(err)) => Err(err)
    (Ok(a), Ok(b)) => if a >= b { Ok(a - b) } else { Ok(b - a) }
  }
}
