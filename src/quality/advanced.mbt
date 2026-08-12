///|
/// Return the mean Phred quality at each observed read position. Positions
/// beyond a short read are excluded from that position's denominator.
pub fn position_quality_profile(content : String) -> Result[Array[Int], String] {
  match @parser.parse_fastq(content) {
    Err(err) => Err(err)
    Ok(records) => {
      if records.length() == 0 {
        return Err("FASTQ input contains no reads")
      }
      let mut maximum_length = 0
      for record in records {
        if record.quality.length() > maximum_length {
          maximum_length = record.quality.length()
        }
      }
      let totals = Array::make(maximum_length, 0)
      let counts = Array::make(maximum_length, 0)
      for record in records {
        match phred_values(record.quality) {
          Err(err) => return Err(err)
          Ok(values) =>
            for i = 0; i < values.length(); i = i + 1 {
              totals[i] = totals[i] + values[i]
              counts[i] = counts[i] + 1
            }
        }
      }
      let profile = Array::make(maximum_length, 0)
      for i = 0; i < maximum_length; i = i + 1 {
        if counts[i] > 0 {
          profile[i] = totals[i] / counts[i]
        }
      }
      Ok(profile)
    }
  }
}

///|
/// Approximate the Phred error probability as parts per million. The integer
/// result is deliberately bucketed by quality decade so it is deterministic
/// on every MoonBit backend and remains useful for pass/fail reporting.
fn phred_error_probability_for_value(value : Int) -> Int {
  if value < 10 {
    1000000
  } else if value < 20 {
    100000
  } else if value < 30 {
    10000
  } else if value < 40 {
    1000
  } else if value < 50 {
    100
  } else if value < 60 {
    10
  } else {
    1
  }
}

///|
pub fn phred_error_probability(quality : String) -> Result[Int, String] {
  match phred_values(quality) {
    Err(err) => Err(err)
    Ok(values) => {
      if values.length() == 0 {
        return Err("error probability requires at least one quality value")
      }
      let mut total = 0
      for value in values {
        total = total + phred_error_probability_for_value(value)
      }
      Ok(total / quality.length())
    }
  }
}

///|
pub fn fastq_has_uniform_length(content : String) -> Result[Bool, String] {
  match @parser.parse_fastq(content) {
    Err(err) => Err(err)
    Ok(records) => {
      if records.length() == 0 {
        return Err("FASTQ input contains no reads")
      }
      let expected = records[0].sequence.length()
      for record in records {
        if record.sequence.length() != expected {
          return Ok(false)
        }
      }
      Ok(true)
    }
  }
}

///|
pub fn quality_pass_rate(
  content : String,
  minimum_mean_quality : Int,
) -> Result[Int, String] {
  match fastq_quality_summary(content, minimum_mean_quality) {
    Err(err) => Err(err)
    Ok(summary) =>
      if summary.read_count == 0 {
        Ok(0)
      } else {
        Ok(summary.passed_reads * 100 / summary.read_count)
      }
  }
}

///|
pub fn low_quality_base_fraction(
  content : String,
  threshold : Int,
) -> Result[Int, String] {
  match fastq_quality_summary(content, threshold) {
    Err(err) => Err(err)
    Ok(summary) =>
      if summary.total_bases == 0 {
        Ok(0)
      } else {
        Ok(summary.low_quality_bases * 100 / summary.total_bases)
      }
  }
}

///|
pub fn trim_fastq_quality(
  content : String,
  threshold : Int,
) -> Result[Array[TrimmedRead], String] {
  match validate_threshold(threshold) {
    Err(err) => Err(err)
    Ok(_) =>
      match @parser.parse_fastq(content) {
        Err(err) => Err(err)
        Ok(records) => {
          let trimmed = []
          for record in records {
            match trim_quality(record.sequence, record.quality, threshold) {
              Err(err) => return Err(err)
              Ok(read) => trimmed.push(read)
            }
          }
          Ok(trimmed)
        }
      }
  }
}
