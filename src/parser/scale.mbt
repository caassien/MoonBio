///|
fn insert_length_descending(lengths : Array[Int], value : Int) -> Unit {
  let position = lengths.length()
  lengths.push(value)
  let mut index = lengths.length() - 1
  while index > 0 && lengths[index - 1] < value {
    lengths[index] = lengths[index - 1]
    index = index - 1
  }
  lengths[index] = value
  if position == 0 {
    lengths[0] = value
  }
}

///|
pub fn fasta_n50(content : String) -> Result[Int, String] {
  match parse_fasta(content) {
    Err(err) => Err(err)
    Ok(records) => {
      if records.length() == 0 {
        return Err("FASTA input contains no records")
      }
      let lengths : Array[Int] = []
      let mut total = 0
      for record in records {
        let length = record.sequence.length()
        total = total + length
        insert_length_descending(lengths, length)
      }
      let threshold = (total + 1) / 2
      let mut cumulative = 0
      for length in lengths {
        cumulative = cumulative + length
        if cumulative >= threshold {
          return Ok(length)
        }
      }
      Ok(0)
    }
  }
}

///|
pub fn validate_unique_fasta_ids(content : String) -> Result[Unit, String] {
  match parse_fasta(content) {
    Err(err) => Err(err)
    Ok(records) => {
      let seen : Array[String] = []
      for record in records {
        for previous in seen {
          if previous == record.id {
            return Err("duplicate FASTA identifier: {record.id}")
          }
        }
        seen.push(record.id)
      }
      Ok(())
    }
  }
}

///|
pub fn fastq_length_histogram(content : String) -> Result[Array[Int], String] {
  match parse_fastq(content) {
    Err(err) => Err(err)
    Ok(records) => {
      if records.length() == 0 {
        return Err("FASTQ input contains no records")
      }
      let mut maximum = 0
      for record in records {
        if record.sequence.length() > maximum {
          maximum = record.sequence.length()
        }
      }
      let histogram = Array::make(maximum + 1, 0)
      for record in records {
        histogram[record.sequence.length()] = histogram[record.sequence.length()] +
          1
      }
      Ok(histogram)
    }
  }
}
