///|
pub struct BioEngine {
  config : AlignmentConfig
} derive(Debug, Eq)

///|
pub fn BioEngine::new() -> BioEngine {
  { config: default_alignment_config() }
}

///|
pub fn BioEngine::with_config(config : AlignmentConfig) -> BioEngine {
  { config, }
}

///|
pub fn BioEngine::global_align(
  self : BioEngine,
  left : String,
  right : String,
) -> @align.AlignmentResult {
  @align.needleman_wunsch(
    normalize_sequence(left),
    normalize_sequence(right),
    self.config.match_score,
    self.config.mismatch_score,
    self.config.gap_penalty,
  )
}

///|
pub fn BioEngine::local_align(
  self : BioEngine,
  left : String,
  right : String,
) -> @align.AlignmentResult {
  @align.smith_waterman(
    normalize_sequence(left),
    normalize_sequence(right),
    self.config.match_score,
    self.config.mismatch_score,
    self.config.gap_penalty,
  )
}

///|
pub fn BioEngine::multiple_align(
  self : BioEngine,
  sequences : Array[String],
) -> @align.MsaResult {
  let normalized = []
  for i = 0; i < sequences.length(); i = i + 1 {
    normalized.push(normalize_sequence(sequences[i]))
  }
  @align.progressive_msa_result(
    normalized,
    self.config.match_score,
    self.config.mismatch_score,
    self.config.gap_penalty,
  )
}

///|
pub fn BioEngine::summarize_fasta(
  self : BioEngine,
  content : String,
) -> Result[String, String] {
  ignore(self)
  match @parser.fasta_summary(content) {
    Err(msg) => Err(msg)
    Ok(stats) =>
      Ok(
        "FASTA records=\{stats.record_count}, total_bases=\{stats.total_bases}, min=\{stats.min_length}, max=\{stats.max_length}",
      )
  }
}

///|
pub fn BioEngine::summarize_fastq(
  self : BioEngine,
  content : String,
) -> Result[String, String] {
  ignore(self)
  match @parser.fastq_summary(content) {
    Err(msg) => Err(msg)
    Ok(stats) =>
      Ok(
        "FASTQ records=\{stats.record_count}, total_bases=\{stats.total_bases}, min=\{stats.min_length}, max=\{stats.max_length}",
      )
  }
}
