///|
test "restriction_sites_and_digest_fragments" {
  let sites = find_restriction_sites("AAGAATTCCGGATCC", "EcoRI").unwrap()
  assert_eq(sites.length(), 1)
  assert_eq(sites[0].start, 2)
  assert_eq(sites[0].cut, 3)
  let fragments = digest_fragments("AAGAATTCCGGATCC", "EcoRI").unwrap()
  assert_eq(fragments[0], 3)
  assert_eq(fragments[1], 12)
}

///|
test "restriction_catalog_and_invalid_enzyme" {
  assert_eq(is_palindromic_site("GAATTC").unwrap(), true)
  assert_eq(restriction_enzyme_names().length(), 4)
  assert_eq(find_restriction_sites("ACGT", "Unknown") is Err(_), true)
  assert_eq(digest_fragments("ACGT", "EcoRI").unwrap()[0], 4)
}
