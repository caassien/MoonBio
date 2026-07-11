///|
pub fn validate_dna_string(sequence : String) -> Result[Unit, String] {
  let normalized = normalize_sequence(sequence)
  if normalized.length() == 0 {
    return Err("sequence must not be empty")
  }
  match @core.parse_dna(normalized) {
    Ok(_) => Ok(())
    Err(msg) => Err(msg)
  }
}

///|
pub fn validate_non_empty_records(
  record_count : Int,
  format_name : String,
) -> Result[Unit, String] {
  if record_count <= 0 {
    Err("\{format_name} input must contain at least one record")
  } else {
    Ok(())
  }
}
