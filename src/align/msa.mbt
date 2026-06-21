/// Simple progressive Multiple Sequence Alignment (MSA).
/// Aligns sequences sequentially to a growing consensus profile
/// (Simplified to align each sequence to the first sequence).
pub fn progressive_msa(sequences: Array[String], match_score: Int, mismatch_score: Int, gap_penalty: Int) -> Array[String] {
  if sequences.length() == 0 {
    return []
  }
  if sequences.length() == 1 {
    return [sequences[0]]
  }

  let aligned = [sequences[0]]
  
  for i = 1; i < sequences.length(); i = i + 1 {
    // We align the new sequence against the current consensus/first sequence
    let current_base = aligned[0]
    let seq = sequences[i]
    let res = needleman_wunsch(current_base, seq, match_score, mismatch_score, gap_penalty)
    
    // In a real MSA, we would insert gaps into all previously aligned sequences 
    // whenever a gap is inserted into the consensus. For simplicity, we just
    // collect the pairwise alignment of the sequence to the consensus.
    aligned[0] = res.alignment_a
    aligned.push(res.alignment_b)
  }

  // Note: The simple progressive alignment may break the length equality
  // if not propagating gaps backward. A full MSA would require a profile matrix.
  // This serves as an initial MVP for the MSA feature.
  aligned
}
