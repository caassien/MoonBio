///|
pub struct RestrictionSite {
  enzyme : String
  pattern : String
  start : Int
  end : Int
  cut : Int
} derive(Eq, Debug)

///|
pub struct RestrictionEnzyme {
  name : String
  pattern : String
  cut_offset : Int
} derive(Eq, Debug)

///|
fn restriction_catalog() -> Array[RestrictionEnzyme] {
  [
    { name: "EcoRI", pattern: "GAATTC", cut_offset: 1 },
    { name: "BamHI", pattern: "GGATCC", cut_offset: 1 },
    { name: "HindIII", pattern: "AAGCTT", cut_offset: 1 },
    { name: "NotI", pattern: "GCGGCCGC", cut_offset: 2 },
  ]
}

///|
pub fn restriction_enzyme_names() -> Array[String] {
  let names = []
  for enzyme in restriction_catalog() {
    names.push(enzyme.name)
  }
  names
}

///|
fn find_enzyme(name : String) -> Result[RestrictionEnzyme, String] {
  for enzyme in restriction_catalog() {
    if enzyme.name == name {
      return Ok(enzyme)
    }
  }
  Err("unknown restriction enzyme: {name}")
}

///|
pub fn find_restriction_sites(
  sequence : String,
  enzyme_name : String,
) -> Result[Array[RestrictionSite], String] {
  match find_enzyme(enzyme_name) {
    Err(err) => Err(err)
    Ok(enzyme) =>
      match find_motif(sequence, enzyme.pattern, false) {
        Err(err) => Err(err)
        Ok(hits) => {
          let sites = []
          for hit in hits {
            sites.push({
              enzyme: enzyme.name,
              pattern: enzyme.pattern,
              start: hit.start,
              end: hit.end,
              cut: hit.start + enzyme.cut_offset,
            })
          }
          Ok(sites)
        }
      }
  }
}

///|
pub fn digest_fragments(
  sequence : String,
  enzyme_name : String,
) -> Result[Array[Int], String] {
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) =>
      match find_restriction_sites(normalized, enzyme_name) {
        Err(err) => Err(err)
        Ok(sites) => {
          let fragments : Array[Int] = []
          let mut previous = 0
          for site in sites {
            fragments.push(site.cut - previous)
            previous = site.cut
          }
          fragments.push(normalized.length() - previous)
          Ok(fragments)
        }
      }
  }
}

///|
pub fn restriction_site_count(
  sequence : String,
  enzyme_name : String,
) -> Result[Int, String] {
  match find_restriction_sites(sequence, enzyme_name) {
    Err(err) => Err(err)
    Ok(sites) => Ok(sites.length())
  }
}

///|
pub fn is_palindromic_site(pattern : String) -> Result[Bool, String] {
  match normalize_dna(pattern) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let reverse = reverse_complement(normalized).unwrap()
      Ok(normalized == reverse)
    }
  }
}
