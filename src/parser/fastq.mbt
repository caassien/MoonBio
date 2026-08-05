///|
pub struct FastqRecord {
  id : String
  sequence : String
  quality : String
} derive(Eq, Debug)

///|
pub struct FastqStats {
  record_count : Int
  total_bases : Int
  min_length : Int
  max_length : Int
} derive(Eq, Debug)

///|
pub fn parse_fastq(content : String) -> Result[Array[FastqRecord], String] {
  let lines = split_lines(content)
  if lines.length() == 0 {
    return Err("FASTQ input is empty")
  }
  if lines.length() % 4 != 0 {
    return Err("FASTQ input must contain a multiple of 4 non-empty lines")
  }

  let records = []
  let mut i = 0
  while i + 3 < lines.length() {
    let id_line = lines[i]
    let sequence_line = lines[i + 1]
    let plus_line = lines[i + 2]
    let quality_line = lines[i + 3]

    if id_line.length() == 0 || id_line[0] != '@' {
      return Err("FASTQ header on line \{i + 1} must start with '@'")
    }
    if id_line.length() == 1 {
      return Err("FASTQ header on line \{i + 1} is missing an identifier")
    }
    if plus_line.length() == 0 || plus_line[0] != '+' {
      return Err("FASTQ separator on line \{i + 3} must start with '+'")
    }
    if sequence_line.length() == 0 {
      return Err("FASTQ sequence on line \{i + 2} is empty")
    }
    match validate_sequence_line(sequence_line, "FASTQ", i + 2) {
      Ok(_) => ()
      Err(msg) => return Err(msg)
    }
    if quality_line.length() != sequence_line.length() {
      return Err(
        "FASTQ quality length on line \{i + 4} does not match sequence length on line \{i + 2}",
      )
    }

    records.push({
      id: id_line[1:].to_owned(),
      sequence: sequence_line,
      quality: quality_line,
    })
    i = i + 4
  }

  Ok(records)
}

///|
pub fn fastq_summary(content : String) -> Result[FastqStats, String] {
  match parse_fastq(content) {
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
/// Return the minimum and maximum Phred+33 quality values in a FASTQ file.
/// The result is `[minimum, maximum]`; an empty quality stream is rejected.
pub fn fastq_quality_range(content : String) -> Result[Array[Int], String] {
  match parse_fastq(content) {
    Err(msg) => Err(msg)
    Ok(records) => {
      if records.length() == 0 {
        return Err("FASTQ input contains no records")
      }
      let first_quality = records[0].quality
      if first_quality.length() == 0 {
        return Err("FASTQ quality data is empty")
      }
      let mut minimum = first_quality[0].to_int() - 33
      let mut maximum = minimum
      for record in records {
        for i = 0; i < record.quality.length(); i = i + 1 {
          let value = record.quality[i].to_int() - 33
          if value < minimum {
            minimum = value
          }
          if value > maximum {
            maximum = value
          }
        }
      }
      Ok([minimum, maximum])
    }
  }
}
