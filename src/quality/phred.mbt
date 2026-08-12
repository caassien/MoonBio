///|
fn validate_threshold(value : Int) -> Result[Unit, String] {
  if value < 0 || value > 93 {
    Err("Phred threshold must be between 0 and 93")
  } else {
    Ok(())
  }
}

///|
pub fn phred_values(quality : String) -> Result[Array[Int], String] {
  let values = []
  for i = 0; i < quality.length(); i = i + 1 {
    let code = quality[i].to_int()
    if code < 33 || code > 126 {
      return Err("quality character at position {i} is outside Phred+33 range")
    }
    values.push(code - 33)
  }
  Ok(values)
}

///|
pub fn mean_quality(quality : String) -> Result[Int, String] {
  match phred_values(quality) {
    Err(err) => Err(err)
    Ok(values) => {
      if values.length() == 0 {
        return Err("mean quality requires at least one base")
      }
      let mut total = 0
      for value in values {
        total = total + value
      }
      Ok(total / quality.length())
    }
  }
}

///|
pub fn n_base_count(sequence : String) -> Int {
  let mut count = 0
  for i = 0; i < sequence.length(); i = i + 1 {
    let c = sequence[i]
    if c == 'N' || c == 'n' {
      count = count + 1
    }
  }
  count
}

///|
pub fn quality_distribution(
  quality : String,
) -> Result[QualityDistribution, String] {
  match phred_values(quality) {
    Err(err) => Err(err)
    Ok(values) => {
      let counts = Array::make(94, 0)
      if values.length() == 0 {
        return Ok({ counts, minimum: 0, maximum: 0, total: 0 })
      }
      let mut minimum = values[0]
      let mut maximum = values[0]
      for value in values {
        counts[value] = counts[value] + 1
        if value < minimum {
          minimum = value
        }
        if value > maximum {
          maximum = value
        }
      }
      Ok({ counts, minimum, maximum, total: quality.length() })
    }
  }
}

///|
pub fn quality_range(quality : String) -> Result[Array[Int], String] {
  match phred_values(quality) {
    Err(err) => Err(err)
    Ok(values) => {
      if values.length() == 0 {
        return Err("quality range requires at least one value")
      }
      let mut minimum = values[0]
      let mut maximum = values[0]
      for value in values {
        if value < minimum {
          minimum = value
        }
        if value > maximum {
          maximum = value
        }
      }
      Ok([minimum, maximum])
    }
  }
}
