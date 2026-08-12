///|
test "quality_profile_aggregates_each_read_position" {
  let fastq = "@a\nACGT\n+\nIIII\n@b\nTGCA\n+\n!5I!\n"
  let profile = position_quality_profile(fastq).unwrap()
  assert_eq(profile[0], 20)
  assert_eq(profile[1], 30)
  assert_eq(profile[2], 40)
  assert_eq(profile[3], 20)
}

///|
test "quality_error_risk_and_read_length_validation" {
  assert_eq(phred_error_probability("!").unwrap(), 1000000)
  assert_eq(phred_error_probability("I").unwrap(), 100)
  assert_eq(
    fastq_has_uniform_length("@a\nAC\n+\nII\n@b\nGT\n+\nHH\n").unwrap(),
    true,
  )
  assert_eq(
    fastq_has_uniform_length("@a\nAC\n+\nII\n@b\nG\n+\nH\n").unwrap(),
    false,
  )
}

///|
test "quality_profile_rejects_empty_and_malformed_inputs" {
  assert_eq(position_quality_profile("") is Err(_), true)
  assert_eq(phred_error_probability("") is Err(_), true)
}

///|
test "low_quality_base_fraction_is_percentage_scaled" {
  let fastq = "@a\nACGT\n+\n!!II\n"
  assert_eq(low_quality_base_fraction(fastq, 20).unwrap(), 50)
}
