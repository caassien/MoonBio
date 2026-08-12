///|
pub struct LengthSummary {
  record_count : Int
  total_bases : Int
  minimum_length : Int
  maximum_length : Int
  n50 : Int
} derive(Eq, Debug)

///|
pub fn fasta_length_summary(content : String) -> Result[LengthSummary, String] {
  match parse_fasta(content) {
    Err(err) => Err(err)
    Ok(records) => {
      if records.length() == 0 {
        return Err("FASTA input contains no records")
      }
      let mut total = 0
      let mut minimum = records[0].sequence.length()
      let mut maximum = minimum
      for record in records {
        let length = record.sequence.length()
        total = total + length
        if length < minimum {
          minimum = length
        }
        if length > maximum {
          maximum = length
        }
      }
      Ok({
        record_count: records.length(),
        total_bases: total,
        minimum_length: minimum,
        maximum_length: maximum,
        n50: fasta_n50(content).unwrap(),
      })
    }
  }
}

///|
pub fn fastq_length_summary(content : String) -> Result[LengthSummary, String] {
  match parse_fastq(content) {
    Err(err) => Err(err)
    Ok(records) => {
      if records.length() == 0 {
        return Err("FASTQ input contains no records")
      }
      let mut total = 0
      let mut minimum = records[0].sequence.length()
      let mut maximum = minimum
      let lengths : Array[Int] = []
      for record in records {
        let length = record.sequence.length()
        lengths.push(length)
        total = total + length
        if length < minimum {
          minimum = length
        }
        if length > maximum {
          maximum = length
        }
      }
      let sorted : Array[Int] = []
      for length in lengths {
        insert_length_descending(sorted, length)
      }
      let threshold = (total + 1) / 2
      let mut cumulative = 0
      let mut n50 = 0
      for length in sorted {
        cumulative = cumulative + length
        if cumulative >= threshold {
          n50 = length
          break
        }
      }
      Ok({
        record_count: records.length(),
        total_bases: total,
        minimum_length: minimum,
        maximum_length: maximum,
        n50,
      })
    }
  }
}
