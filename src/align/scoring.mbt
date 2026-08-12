///|
pub struct AlignmentSummary {
  columns : Int
  matches : Int
  mismatches : Int
  insertions : Int
  deletions : Int
  identity_percent : Int
  edit_distance : Int
} derive(Eq, Debug)

///|
pub fn validate_alignment(
  alignment_a : String,
  alignment_b : String,
) -> Result[Unit, String] {
  if alignment_a.length() != alignment_b.length() {
    return Err("aligned sequences must have equal lengths")
  }
  for i = 0; i < alignment_a.length(); i = i + 1 {
    match alignment_operation(alignment_a[i], alignment_b[i]) {
      Err(err) => return Err(err)
      Ok(_) => ()
    }
  }
  Ok(())
}

///|
pub fn summarize_alignment(
  alignment_a : String,
  alignment_b : String,
) -> Result[AlignmentSummary, String] {
  match validate_alignment(alignment_a, alignment_b) {
    Err(err) => Err(err)
    Ok(_) => {
      let mut matches = 0
      let mut mismatches = 0
      let mut insertions = 0
      let mut deletions = 0
      for i = 0; i < alignment_a.length(); i = i + 1 {
        let left = alignment_a[i]
        let right = alignment_b[i]
        if left == '-' {
          insertions = insertions + 1
        } else if right == '-' {
          deletions = deletions + 1
        } else if left == right {
          matches = matches + 1
        } else {
          mismatches = mismatches + 1
        }
      }
      let edits = mismatches + insertions + deletions
      let identity = if alignment_a.length() == 0 {
        0
      } else {
        matches * 100 / alignment_a.length()
      }
      Ok({
        columns: alignment_a.length(),
        matches,
        mismatches,
        insertions,
        deletions,
        identity_percent: identity,
        edit_distance: edits,
      })
    }
  }
}

///|
pub fn score_alignment(
  alignment_a : String,
  alignment_b : String,
  match_score : Int,
  mismatch_score : Int,
  gap_penalty : Int,
) -> Result[Int, String] {
  match validate_alignment(alignment_a, alignment_b) {
    Err(err) => Err(err)
    Ok(_) => {
      let mut score = 0
      for i = 0; i < alignment_a.length(); i = i + 1 {
        if alignment_a[i] == '-' || alignment_b[i] == '-' {
          score = score + gap_penalty
        } else if alignment_a[i] == alignment_b[i] {
          score = score + match_score
        } else {
          score = score + mismatch_score
        }
      }
      Ok(score)
    }
  }
}

///|
pub fn aligned_reference_coordinates(
  aligned_reference : String,
  reference_start : Int,
) -> Result[Array[Int], String] {
  if reference_start < 0 {
    return Err("reference start cannot be negative")
  }
  let coordinates = []
  let mut coordinate = reference_start
  for i = 0; i < aligned_reference.length(); i = i + 1 {
    if aligned_reference[i] == '-' {
      coordinates.push(-1)
    } else {
      coordinates.push(coordinate)
      coordinate = coordinate + 1
    }
  }
  Ok(coordinates)
}

///|
pub fn ungap(aligned_sequence : String) -> Result[String, String] {
  let mut output = ""
  for i = 0; i < aligned_sequence.length(); i = i + 1 {
    if aligned_sequence[i] != '-' {
      output = output +
        aligned_sequence[i].to_int().unsafe_to_char().to_string()
    }
  }
  Ok(output)
}

///|
pub fn alignment_mismatch_positions(
  alignment_a : String,
  alignment_b : String,
) -> Result[Array[Int], String] {
  match validate_alignment(alignment_a, alignment_b) {
    Err(err) => Err(err)
    Ok(_) => {
      let positions = []
      for i = 0; i < alignment_a.length(); i = i + 1 {
        if alignment_a[i] != alignment_b[i] {
          positions.push(i)
        }
      }
      Ok(positions)
    }
  }
}

///|
pub fn alignment_coverage_percent(alignment : String) -> Result[Int, String] {
  if alignment.length() == 0 {
    return Ok(0)
  }
  let mut covered = 0
  for i = 0; i < alignment.length(); i = i + 1 {
    if alignment[i] != '-' {
      covered = covered + 1
    }
  }
  Ok(covered * 100 / alignment.length())
}
