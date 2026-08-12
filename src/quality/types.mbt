///|
pub struct QualityDistribution {
  counts : Array[Int]
  minimum : Int
  maximum : Int
  total : Int
} derive(Debug)

///|
pub struct FastqQualitySummary {
  read_count : Int
  passed_reads : Int
  failed_reads : Int
  total_bases : Int
  passed_bases : Int
  n_bases : Int
  mean_quality : Int
  low_quality_bases : Int
} derive(Debug)

///|
pub struct TrimmedRead {
  sequence : String
  quality : String
  left_trim : Int
  right_trim : Int
  retained_length : Int
} derive(Debug)

///|
pub struct QualityFilterConfig {
  minimum_length : Int
  minimum_mean_quality : Int
} derive(Debug, Eq)

///|
pub struct FilterSummary {
  total_reads : Int
  passed_reads : Int
  failed_reads : Int
  total_bases : Int
  passed_bases : Int
} derive(Debug, Eq)
