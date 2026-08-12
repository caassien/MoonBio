///|
pub struct CodonUsage {
  codon : String
  amino : String
  count : Int
  fraction_percent : Int
} derive(Eq, Debug)

///|
pub struct CodingReport {
  frame : Int
  codons_read : Int
  start_codons : Int
  stop_codons : Int
  gc_percent : Int
  protein : String
} derive(Eq, Debug)

///|
pub fn translate_all_frames(
  sequence : String,
) -> Result[Array[TranslationResult], String] {
  let results = []
  for frame = 0; frame < 3; frame = frame + 1 {
    match translate(sequence, frame) {
      Err(err) => return Err(err)
      Ok(result) => results.push(result)
    }
  }
  Ok(results)
}

///|
fn is_start_codon(codon : String) -> Bool {
  codon == "ATG"
}

///|
fn is_stop_codon(codon : String) -> Bool {
  codon == "TAA" || codon == "TAG" || codon == "TGA"
}

///|
pub fn coding_report(
  sequence : String,
  frame : Int,
) -> Result[CodingReport, String] {
  if frame < 0 || frame > 2 {
    return Err("coding report frame must be 0, 1, or 2")
  }
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let mut codons_read = 0
      let mut start_codons = 0
      let mut stop_codons = 0
      let mut position = frame
      while position + 2 < normalized.length() {
        let codon = normalized[position:position + 3].to_owned()
        if is_start_codon(codon) {
          start_codons = start_codons + 1
        }
        if is_stop_codon(codon) {
          stop_codons = stop_codons + 1
        }
        codons_read = codons_read + 1
        position = position + 3
      }
      let translation = translate(normalized, frame).unwrap()
      let gc = gc_percent(normalized).unwrap()
      Ok({
        frame,
        codons_read,
        start_codons,
        stop_codons,
        gc_percent: gc,
        protein: translation.protein,
      })
    }
  }
}

///|
pub fn codon_usage(
  sequence : String,
  frame : Int,
) -> Result[Array[CodonUsage], String] {
  if frame < 0 || frame > 2 {
    return Err("codon usage frame must be 0, 1, or 2")
  }
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      let items : Array[CodonUsage] = []
      let mut position = frame
      let mut total = 0
      while position + 2 < normalized.length() {
        let codon = normalized[position:position + 3].to_owned()
        let amino = codon_to_amino(codon).unwrap()
        let mut found = false
        for i = 0; i < items.length(); i = i + 1 {
          if items[i].codon == codon {
            items[i] = {
              codon: items[i].codon,
              amino: items[i].amino,
              count: items[i].count + 1,
              fraction_percent: 0,
            }
            found = true
            break
          }
        }
        if !found {
          items.push({ codon, amino, count: 1, fraction_percent: 0 })
        }
        total = total + 1
        position = position + 3
      }
      if total == 0 {
        return Ok([])
      }
      for i = 0; i < items.length(); i = i + 1 {
        let item = items[i]
        items[i] = {
          codon: item.codon,
          amino: item.amino,
          count: item.count,
          fraction_percent: item.count * 100 / total,
        }
      }
      Ok(items)
    }
  }
}

///|
pub fn sequence_complexity(sequence : String, k : Int) -> Result[Int, String] {
  match total_kmers(sequence, k) {
    Err(err) => Err(err)
    Ok(total) =>
      if total == 0 {
        Ok(0)
      } else {
        let unique = unique_kmer_count(sequence, k).unwrap()
        Ok(unique * 100 / total)
      }
  }
}

///|
pub fn minimizer_sketch(
  sequence : String,
  k : Int,
  window_kmers : Int,
) -> Result[Array[String], String] {
  if k < 1 {
    return Err("minimizer k-mer size must be positive")
  }
  if window_kmers < 1 {
    return Err("minimizer window must be positive")
  }
  match normalize_dna(sequence) {
    Err(err) => Err(err)
    Ok(normalized) => {
      if normalized.length() < k {
        return Err("minimizer k-mer size exceeds sequence length")
      }
      let kmer_total = normalized.length() - k + 1
      let effective_window = if window_kmers > kmer_total {
        kmer_total
      } else {
        window_kmers
      }
      let minimizers = []
      for start = 0; start + effective_window <= kmer_total; start = start + 1 {
        let mut best = normalized[start:start + k].to_owned()
        for offset = 1; offset < effective_window; offset = offset + 1 {
          let candidate = normalized[start + offset:start + offset + k].to_owned()
          if compare_text(candidate, best) < 0 {
            best = candidate
          }
        }
        if minimizers.length() == 0 ||
          minimizers[minimizers.length() - 1] != best {
          minimizers.push(best)
        }
      }
      Ok(minimizers)
    }
  }
}
