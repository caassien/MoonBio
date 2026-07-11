///|
pub fn wasm_init() -> String {
  "MoonBio WASM module ready"
}

///|
pub fn demo_global_alignment() -> String {
  let result = @align.needleman_wunsch("GATTACA", "GCATGCU", 1, -1, -1)
  "score=\{result.score};a=\{result.alignment_a};b=\{result.alignment_b}"
}

///|
pub fn demo_msa() -> String {
  let result = @align.progressive_msa_result(
    ["GATTACA", "GCATGCU", "GACTACA"],
    1,
    -1,
    -1,
  )
  "consensus=\{result.consensus};count=\{result.aligned_sequences.length()}"
}

///|
pub fn demo_fasta_summary() -> String {
  match @parser.fasta_summary(">seq1\nGATTACA\n>seq2\nGACTATA\n") {
    Ok(stats) => "records=\{stats.record_count};bases=\{stats.total_bases}"
    Err(msg) => "error=\{msg}"
  }
}

///|
fn main {
  ignore(wasm_init())
}
