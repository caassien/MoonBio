///|
pub struct ReadQualityRecord {
  id : String
  length : Int
  mean_quality : Int
  minimum_quality : Int
  maximum_quality : Int
  n_bases : Int
  passed : Bool
} derive(Eq, Debug)

///|
pub fn per_read_quality_report(
  content : String,
  minimum_mean_quality : Int,
) -> Result[Array[ReadQualityRecord], String] {
  match validate_threshold(minimum_mean_quality) {
    Err(err) => Err(err)
    Ok(_) =>
      match @parser.parse_fastq(content) {
        Err(err) => Err(err)
        Ok(records) => {
          let report : Array[ReadQualityRecord] = []
          for record in records {
            match phred_values(record.quality) {
              Err(err) => return Err(err)
              Ok(values) => {
                if values.length() == 0 {
                  return Err("FASTQ record has empty quality data")
                }
                let mut total = 0
                let mut minimum = values[0]
                let mut maximum = values[0]
                for value in values {
                  total = total + value
                  if value < minimum {
                    minimum = value
                  }
                  if value > maximum {
                    maximum = value
                  }
                }
                let mean = total / values.length()
                report.push({
                  id: record.id,
                  length: record.sequence.length(),
                  mean_quality: mean,
                  minimum_quality: minimum,
                  maximum_quality: maximum,
                  n_bases: n_base_count(record.sequence),
                  passed: mean >= minimum_mean_quality,
                })
              }
            }
          }
          Ok(report)
        }
      }
  }
}

///|
pub fn read_pass_mask(
  content : String,
  minimum_mean_quality : Int,
) -> Result[Array[Bool], String] {
  match per_read_quality_report(content, minimum_mean_quality) {
    Err(err) => Err(err)
    Ok(records) => {
      let mask = []
      for record in records {
        mask.push(record.passed)
      }
      Ok(mask)
    }
  }
}
