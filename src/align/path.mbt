///|
fn alignment_operation(a : UInt16, b : UInt16) -> Result[Char, String] {
  let left = a.to_int().unsafe_to_char()
  let right = b.to_int().unsafe_to_char()
  if left == '-' && right == '-' {
    Err("an alignment column cannot contain two gaps")
  } else if left == '-' {
    Ok('I')
  } else if right == '-' {
    Ok('D')
  } else {
    Ok('M')
  }
}

///|
pub fn alignment_cigar(
  alignment_a : String,
  alignment_b : String,
) -> Result[String, String] {
  if alignment_a.length() != alignment_b.length() {
    return Err("aligned sequences must have equal lengths")
  }
  if alignment_a.length() == 0 {
    return Ok("")
  }
  let mut cigar = ""
  let mut current = 'M'
  let mut run = 0
  for i = 0; i < alignment_a.length(); i = i + 1 {
    match alignment_operation(alignment_a[i], alignment_b[i]) {
      Err(err) => return Err(err)
      Ok(operation) =>
        if run == 0 {
          current = operation
          run = 1
        } else if operation == current {
          run = run + 1
        } else {
          cigar = cigar + run.to_string() + current.to_string()
          current = operation
          run = 1
        }
    }
  }
  Ok(cigar + run.to_string() + current.to_string())
}

///|
pub fn alignment_identity(
  alignment_a : String,
  alignment_b : String,
) -> Result[Int, String] {
  if alignment_a.length() != alignment_b.length() {
    return Err("aligned sequences must have equal lengths")
  }
  if alignment_a.length() == 0 {
    return Ok(0)
  }
  let mut matches = 0
  for i = 0; i < alignment_a.length(); i = i + 1 {
    match alignment_operation(alignment_a[i], alignment_b[i]) {
      Err(err) => return Err(err)
      Ok(_) =>
        if alignment_a[i] == alignment_b[i] && alignment_a[i] != '-' {
          matches = matches + 1
        }
    }
  }
  Ok(matches * 100 / alignment_a.length())
}

///|
pub fn alignment_edit_distance(
  alignment_a : String,
  alignment_b : String,
) -> Result[Int, String] {
  if alignment_a.length() != alignment_b.length() {
    return Err("aligned sequences must have equal lengths")
  }
  let mut edits = 0
  for i = 0; i < alignment_a.length(); i = i + 1 {
    match alignment_operation(alignment_a[i], alignment_b[i]) {
      Err(err) => return Err(err)
      Ok(_) => if alignment_a[i] != alignment_b[i] { edits = edits + 1 }
    }
  }
  Ok(edits)
}
