///|
pub fn quality_filter_config(
  minimum_length : Int,
  minimum_mean_quality : Int,
) -> Result[QualityFilterConfig, String] {
  if minimum_length < 0 {
    return Err("minimum FASTQ length cannot be negative")
  }
  match validate_threshold(minimum_mean_quality) {
    Err(err) => Err(err)
    Ok(_) => Ok({ minimum_length, minimum_mean_quality })
  }
}

///|
pub fn fastq_quality_summary(
  content : String,
  minimum_mean_quality : Int,
) -> Result[FastqQualitySummary, String] {
  match validate_threshold(minimum_mean_quality) {
    Err(err) => Err(err)
    Ok(_) =>
      match @parser.parse_fastq(content) {
        Err(err) => Err(err)
        Ok(records) => {
          let read_count = records.length()
          let mut passed_reads = 0
          let mut total_bases = 0
          let mut passed_bases = 0
          let mut n_bases = 0
          let mut low_quality_bases = 0
          let mut quality_total = 0
          for record in records {
            let length = record.sequence.length()
            total_bases = total_bases + length
            n_bases = n_bases + n_base_count(record.sequence)
            match phred_values(record.quality) {
              Err(err) => return Err(err)
              Ok(values) => {
                let mut read_quality_total = 0
                for value in values {
                  read_quality_total = read_quality_total + value
                  quality_total = quality_total + value
                  if value < minimum_mean_quality {
                    low_quality_bases = low_quality_bases + 1
                  }
                }
                let read_mean = read_quality_total / length
                if read_mean >= minimum_mean_quality {
                  passed_reads = passed_reads + 1
                  passed_bases = passed_bases + length
                }
              }
            }
          }
          let mean_quality = if total_bases == 0 {
            0
          } else {
            quality_total / total_bases
          }
          Ok({
            read_count,
            passed_reads,
            failed_reads: read_count - passed_reads,
            total_bases,
            passed_bases,
            n_bases,
            mean_quality,
            low_quality_bases,
          })
        }
      }
  }
}

///|
pub fn filter_fastq(
  content : String,
  minimum_length : Int,
  minimum_mean_quality : Int,
) -> Result[FilterSummary, String] {
  match quality_filter_config(minimum_length, minimum_mean_quality) {
    Err(err) => Err(err)
    Ok(config) =>
      match @parser.parse_fastq(content) {
        Err(err) => Err(err)
        Ok(records) => {
          let total_reads = records.length()
          let mut passed_reads = 0
          let mut total_bases = 0
          let mut passed_bases = 0
          for record in records {
            let length = record.sequence.length()
            total_bases = total_bases + length
            match mean_quality(record.quality) {
              Err(err) => return Err(err)
              Ok(quality) =>
                if length >= config.minimum_length &&
                  quality >= config.minimum_mean_quality {
                  passed_reads = passed_reads + 1
                  passed_bases = passed_bases + length
                }
            }
          }
          Ok({
            total_reads,
            passed_reads,
            failed_reads: total_reads - passed_reads,
            total_bases,
            passed_bases,
          })
        }
      }
  }
}
