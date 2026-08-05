///|
pub struct FastaRecord {
  id : String
  sequence : String
} derive(Eq, Debug)

///|
pub struct FastaStats {
  record_count : Int
  total_bases : Int
  min_length : Int
  max_length : Int
} derive(Eq, Debug)

///|
fn split_lines(content : String) -> Array[String] {
  let lines = []
  let mut current = ""
  for i = 0; i < content.length(); i = i + 1 {
    let c = content[i]
    if c == '\n' {
      if current.length() > 0 && current[current.length() - 1] == '\r' {
        current = current[:current.length() - 1].to_owned()
      }
      lines.push(current)
      current = ""
    } else {
      current = current + c.to_int().unsafe_to_char().to_string()
    }
  }
  if current.length() > 0 {
    lines.push(current)
  }
  lines
}

///|
fn is_valid_sequence_symbol(c : UInt16) -> Bool {
  let char = c.to_int().unsafe_to_char()
  if char >= 'A' && char <= 'Z' {
    true
  } else if char >= 'a' && char <= 'z' {
    true
  } else {
    char == '*' || char == '-' || char == '?'
  }
}

///|
fn validate_sequence_line(
  line : String,
  format_name : String,
  line_no : Int,
) -> Result[Unit, String] {
  for i = 0; i < line.length(); i = i + 1 {
    let c = line[i]
    if !is_valid_sequence_symbol(c) {
      return Err(
        "\{format_name} line \{line_no} contains invalid character: \{c.to_int().unsafe_to_char().to_string()}",
      )
    }
  }
  Ok(())
}

///|
fn finalize_fasta_record(
  records : Array[FastaRecord],
  current_id : String,
  current_sequence : String,
) -> Result[Unit, String] {
  if current_id.length() == 0 {
    return Err("FASTA header must contain a non-empty identifier")
  }
  if current_sequence.length() == 0 {
    return Err("FASTA record '\{current_id}' does not contain sequence data")
  }
  records.push({ id: current_id, sequence: current_sequence })
  Ok(())
}

///|
pub fn parse_fasta(content : String) -> Result[Array[FastaRecord], String] {
  let lines = split_lines(content)
  if lines.length() == 0 {
    return Err("FASTA input is empty")
  }

  let records = []
  let mut current_id = ""
  let mut current_sequence = ""
  let mut saw_header = false

  for i = 0; i < lines.length(); i = i + 1 {
    let line = lines[i]
    if line.length() == 0 {
      continue
    }
    if line[0] == '>' {
      if saw_header {
        match finalize_fasta_record(records, current_id, current_sequence) {
          Ok(_) => ()
          Err(msg) => return Err(msg)
        }
      }
      if line.length() == 1 {
        return Err("FASTA header on line \{i + 1} is missing an identifier")
      }
      current_id = line[1:].to_owned()
      current_sequence = ""
      saw_header = true
    } else {
      if !saw_header {
        return Err("FASTA sequence data appears before the first header")
      }
      match validate_sequence_line(line, "FASTA", i + 1) {
        Ok(_) => ()
        Err(msg) => return Err(msg)
      }
      current_sequence = current_sequence + line
    }
  }

  if !saw_header {
    return Err("No FASTA header was found in the input")
  }

  match finalize_fasta_record(records, current_id, current_sequence) {
    Ok(_) => Ok(records)
    Err(msg) => Err(msg)
  }
}

///|
pub fn fasta_summary(content : String) -> Result[FastaStats, String] {
  match parse_fasta(content) {
    Err(msg) => Err(msg)
    Ok(records) => {
      let mut total_bases = 0
      let mut min_length = records[0].sequence.length()
      let mut max_length = records[0].sequence.length()
      for i = 0; i < records.length(); i = i + 1 {
        let length = records[i].sequence.length()
        total_bases = total_bases + length
        if length < min_length {
          min_length = length
        }
        if length > max_length {
          max_length = length
        }
      }
      Ok({ record_count: records.length(), total_bases, min_length, max_length })
    }
  }
}

///|
/// Return the GC percentage of all canonical bases in a FASTA document.
/// Ambiguous symbols are accepted by the parser but are excluded from the
/// denominator, which keeps the metric explicit and reproducible.
pub fn fasta_gc_percent(content : String) -> Result[Int, String] {
  match parse_fasta(content) {
    Err(msg) => Err(msg)
    Ok(records) => {
      let mut gc = 0
      let mut canonical = 0
      for record in records {
        for i = 0; i < record.sequence.length(); i = i + 1 {
          let c = record.sequence[i]
          if c == 'A' ||
            c == 'a' ||
            c == 'C' ||
            c == 'c' ||
            c == 'G' ||
            c == 'g' ||
            c == 'T' ||
            c == 't' {
            canonical = canonical + 1
            if c == 'C' || c == 'c' || c == 'G' || c == 'g' {
              gc = gc + 1
            }
          }
        }
      }
      if canonical == 0 {
        Ok(0)
      } else {
        Ok(gc * 100 / canonical)
      }
    }
  }
}
