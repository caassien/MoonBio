///|
pub struct SymbolSummary {
  a : Int
  c : Int
  g : Int
  t : Int
  n : Int
  other : Int
  total : Int
} derive(Eq, Debug)

///|
fn add_symbol(summary : SymbolSummary, symbol : UInt16) -> SymbolSummary {
  let base = if symbol >= 'a' && symbol <= 'z' {
    symbol - ('a' - 'A')
  } else {
    symbol
  }
  if base == 'A' {
    { ..summary, a: summary.a + 1, total: summary.total + 1 }
  } else if base == 'C' {
    { ..summary, c: summary.c + 1, total: summary.total + 1 }
  } else if base == 'G' {
    { ..summary, g: summary.g + 1, total: summary.total + 1 }
  } else if base == 'T' || base == 'U' {
    { ..summary, t: summary.t + 1, total: summary.total + 1 }
  } else if base == 'N' {
    { ..summary, n: summary.n + 1, total: summary.total + 1 }
  } else {
    { ..summary, other: summary.other + 1, total: summary.total + 1 }
  }
}

///|
pub fn fasta_symbol_summary(content : String) -> Result[SymbolSummary, String] {
  match parse_fasta(content) {
    Err(err) => Err(err)
    Ok(records) => {
      let mut summary : SymbolSummary = {
        a: 0,
        c: 0,
        g: 0,
        t: 0,
        n: 0,
        other: 0,
        total: 0,
      }
      for record in records {
        for i = 0; i < record.sequence.length(); i = i + 1 {
          summary = add_symbol(summary, record.sequence[i])
        }
      }
      Ok(summary)
    }
  }
}

///|
pub fn fastq_symbol_summary(content : String) -> Result[SymbolSummary, String] {
  match parse_fastq(content) {
    Err(err) => Err(err)
    Ok(records) => {
      let mut summary : SymbolSummary = {
        a: 0,
        c: 0,
        g: 0,
        t: 0,
        n: 0,
        other: 0,
        total: 0,
      }
      for record in records {
        for i = 0; i < record.sequence.length(); i = i + 1 {
          summary = add_symbol(summary, record.sequence[i])
        }
      }
      Ok(summary)
    }
  }
}

///|
pub fn fasta_n_fraction(content : String) -> Result[Int, String] {
  match fasta_symbol_summary(content) {
    Err(err) => Err(err)
    Ok(summary) =>
      if summary.total == 0 {
        Ok(0)
      } else {
        Ok(summary.n * 100 / summary.total)
      }
  }
}

///|
pub fn fastq_n_fraction(content : String) -> Result[Int, String] {
  match fastq_symbol_summary(content) {
    Err(err) => Err(err)
    Ok(summary) =>
      if summary.total == 0 {
        Ok(0)
      } else {
        Ok(summary.n * 100 / summary.total)
      }
  }
}
