///|
pub fn low_quality_windows(
  quality : String,
  window : Int,
  threshold : Int,
) -> Result[Array[Int], String] {
  match validate_threshold(threshold) {
    Err(err) => Err(err)
    Ok(_) => {
      if window < 1 {
        return Err("quality window must be positive")
      }
      match phred_values(quality) {
        Err(err) => Err(err)
        Ok(values) => {
          if window > values.length() {
            return Err("quality window exceeds quality string length")
          }
          let starts = []
          for start = 0; start <= values.length() - window; start = start + 1 {
            let mut total = 0
            for i = start; i < start + window; i = i + 1 {
              total = total + values[i]
            }
            if total / window < threshold {
              starts.push(start)
            }
          }
          Ok(starts)
        }
      }
    }
  }
}

///|
pub fn trim_quality(
  sequence : String,
  quality : String,
  threshold : Int,
) -> Result[TrimmedRead, String] {
  match validate_threshold(threshold) {
    Err(err) => Err(err)
    Ok(_) => {
      if sequence.length() != quality.length() {
        return Err("sequence and quality lengths must match")
      }
      match phred_values(quality) {
        Err(err) => Err(err)
        Ok(values) => {
          let mut left = 0
          while left < values.length() && values[left] < threshold {
            left = left + 1
          }
          let mut right = values.length()
          while right > left && values[right - 1] < threshold {
            right = right - 1
          }
          Ok({
            sequence: sequence[left:right].to_owned(),
            quality: quality[left:right].to_owned(),
            left_trim: left,
            right_trim: values.length() - right,
            retained_length: right - left,
          })
        }
      }
    }
  }
}
