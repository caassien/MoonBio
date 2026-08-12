///|
pub struct QualityWindowStatistic {
  start : Int
  end : Int
  mean_quality : Int
  minimum_quality : Int
  maximum_quality : Int
  low_quality_bases : Int
} derive(Eq, Debug)

///|
pub fn quality_window_profile(
  quality : String,
  window : Int,
) -> Result[Array[QualityWindowStatistic], String] {
  if window < 1 {
    return Err("quality profile window must be positive")
  }
  match phred_values(quality) {
    Err(err) => Err(err)
    Ok(values) => {
      if window > values.length() {
        return Err("quality profile window exceeds quality length")
      }
      let profile = []
      for start = 0; start + window <= values.length(); start = start + 1 {
        let mut total = 0
        let mut minimum = values[start]
        let mut maximum = values[start]
        let mut low = 0
        for i = start; i < start + window; i = i + 1 {
          let value = values[i]
          total = total + value
          if value < minimum {
            minimum = value
          }
          if value > maximum {
            maximum = value
          }
          if value < 20 {
            low = low + 1
          }
        }
        profile.push({
          start,
          end: start + window,
          mean_quality: total / window,
          minimum_quality: minimum,
          maximum_quality: maximum,
          low_quality_bases: low,
        })
      }
      Ok(profile)
    }
  }
}

///|
pub fn quality_window_passes(
  quality : String,
  window : Int,
  minimum_mean_quality : Int,
) -> Result[Array[Bool], String] {
  match quality_window_profile(quality, window) {
    Err(err) => Err(err)
    Ok(profile) => {
      let passed = []
      for item in profile {
        passed.push(item.mean_quality >= minimum_mean_quality)
      }
      Ok(passed)
    }
  }
}
