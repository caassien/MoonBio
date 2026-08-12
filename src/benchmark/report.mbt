///|
pub struct BenchmarkReport {
  sequence_count : Int
  total_bases : Int
  average_gc_percent : Int
  total_motif_hits : Int
  alignment_identity_percent : Int
  alignment_cigar : String
  quality_total_reads : Int
  quality_passed_reads : Int
} derive(Eq, Debug)

///|
pub fn run_benchmark(motif : String) -> Result[BenchmarkReport, String] {
  if motif.length() == 0 {
    return Err("benchmark motif must not be empty")
  }
  let references = reference_sequences()
  let mut total_bases = 0
  let mut total_gc = 0
  let mut total_motif_hits = 0
  for reference in references {
    match @sequence.sequence_length(reference.sequence) {
      Err(err) => return Err(err)
      Ok(length) => total_bases = total_bases + length
    }
    match @sequence.gc_percent(reference.sequence) {
      Err(err) => return Err(err)
      Ok(gc) => total_gc = total_gc + gc
    }
    match @sequence.find_motif(reference.sequence, motif, true) {
      Err(err) => return Err(err)
      Ok(hits) => total_motif_hits = total_motif_hits + hits.length()
    }
  }
  let first = references[0].sequence
  let shortened = first[1:].to_owned()
  let alignment = @align.needleman_wunsch(first, shortened, 2, -1, -2)
  let identity = match
    @align.alignment_identity(alignment.alignment_a, alignment.alignment_b) {
    Err(err) => return Err(err)
    Ok(value) => value
  }
  let cigar = match
    @align.alignment_cigar(alignment.alignment_a, alignment.alignment_b) {
    Err(err) => return Err(err)
    Ok(value) => value
  }
  let quality = match @quality.fastq_quality_summary(reference_fastq(), 20) {
    Err(err) => return Err(err)
    Ok(value) => value
  }
  Ok({
    sequence_count: references.length(),
    total_bases,
    average_gc_percent: total_gc / references.length(),
    total_motif_hits,
    alignment_identity_percent: identity,
    alignment_cigar: cigar,
    quality_total_reads: quality.read_count,
    quality_passed_reads: quality.passed_reads,
  })
}
