///|
fn scan_orfs(
  sequence : String,
  strand : String,
  minimum_codons : Int,
) -> Array[Orf] {
  let orfs = []
  if sequence.length() < minimum_codons * 3 {
    return orfs
  }
  for frame = 0; frame < 3; frame = frame + 1 {
    let mut start = frame
    while start + 2 < sequence.length() {
      if sequence[start] == 'A' &&
        sequence[start + 1] == 'T' &&
        sequence[start + 2] == 'G' {
        let mut cursor = start
        let mut codons = 0
        let mut found_stop = false
        while cursor + 2 < sequence.length() {
          let codon = sequence[cursor:cursor + 3].to_owned()
          match codon_to_amino(codon) {
            Err(_) => cursor = sequence.length()
            Ok(amino) => {
              codons = codons + 1
              cursor = cursor + 3
              if amino == "*" {
                found_stop = true
                break
              }
            }
          }
        }
        if found_stop && codons >= minimum_codons {
          orfs.push({
            start,
            end: start + codons * 3,
            frame,
            strand,
            protein: translate(sequence[start:start + codons * 3].to_owned(), 0).unwrap().protein,
          })
          start = cursor
        } else {
          start = start + 3
        }
      } else {
        start = start + 3
      }
    }
  }
  orfs
}

///|
pub fn find_orfs(
  sequence : String,
  minimum_codons : Int,
) -> Result[Array[Orf], String] {
  if minimum_codons < 2 {
    return Err("minimum ORF length must include at least start and stop codons")
  }
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let result = scan_orfs(normalized, "forward", minimum_codons)
      match reverse_complement(normalized) {
        Err(err) => Err(err)
        Ok(reverse) => {
          let reverse_orfs = scan_orfs(reverse, "reverse", minimum_codons)
          for item in reverse_orfs {
            result.push({
              start: normalized.length() - item.end,
              end: normalized.length() - item.start,
              frame: item.frame,
              strand: item.strand,
              protein: item.protein,
            })
          }
          Ok(result)
        }
      }
    }
  }
}

///|
pub fn orf_count(
  sequence : String,
  minimum_codons : Int,
) -> Result[Int, String] {
  match find_orfs(sequence, minimum_codons) {
    Err(err) => Err(err)
    Ok(orfs) => Ok(orfs.length())
  }
}
