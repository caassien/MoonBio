///|
test "quality_window_profile_reports_mean_and_low_base_count" {
  let profile = quality_window_profile("II!!II", 3).unwrap()
  assert_eq(profile[0].mean_quality, 26)
  assert_eq(profile[0].low_quality_bases, 1)
  assert_eq(profile[1].mean_quality, 13)
  assert_eq(profile[1].low_quality_bases, 2)
}

///|
test "quality_window_profile_rejects_invalid_window" {
  assert_eq(quality_window_profile("IIII", 0) is Err(_), true)
  assert_eq(quality_window_profile("II", 3) is Err(_), true)
}
