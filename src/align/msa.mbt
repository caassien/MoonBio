///|
pub struct MsaResult {
  aligned_sequences : Array[String]
  consensus : String
  total_score : Int
} derive(Eq, Debug)

///|
fn append_column(
  targets : Array[String],
  source : Array[String],
  column : Int,
) -> Unit {
  for i = 0; i < source.length(); i = i + 1 {
    targets[i] = targets[i] +
      source[i][column].to_int().unsafe_to_char().to_string()
  }
}

///|
fn append_gap_column(targets : Array[String]) -> Unit {
  for i = 0; i < targets.length(); i = i + 1 {
    targets[i] = targets[i] + "-"
  }
}

///|
fn build_consensus(aligned_sequences : Array[String]) -> String {
  if aligned_sequences.length() == 0 {
    return ""
  }

  let width = aligned_sequences[0].length()
  let mut consensus = ""
  for column = 0; column < width; column = column + 1 {
    let counts = [0, 0, 0, 0, 0]
    for row = 0; row < aligned_sequences.length(); row = row + 1 {
      let c = aligned_sequences[row][column]
      if c == 'A' || c == 'a' {
        counts[0] = counts[0] + 1
      } else if c == 'C' || c == 'c' {
        counts[1] = counts[1] + 1
      } else if c == 'G' || c == 'g' {
        counts[2] = counts[2] + 1
      } else if c == 'T' || c == 't' || c == 'U' || c == 'u' {
        counts[3] = counts[3] + 1
      } else if c != '-' {
        counts[4] = counts[4] + 1
      }
    }

    let mut best_index = 4
    for idx = 0; idx < 4; idx = idx + 1 {
      if counts[idx] > counts[best_index] {
        best_index = idx
      }
    }

    let best_char = if best_index == 0 {
      "A"
    } else if best_index == 1 {
      "C"
    } else if best_index == 2 {
      "G"
    } else if best_index == 3 {
      "T"
    } else {
      "N"
    }
    consensus = consensus + best_char
  }
  consensus
}

///|
pub fn progressive_msa_result(
  sequences : Array[String],
  match_score : Int,
  mismatch_score : Int,
  gap_penalty : Int,
) -> MsaResult {
  if sequences.length() == 0 {
    return { aligned_sequences: [], consensus: "", total_score: 0 }
  }
  if sequences.length() == 1 {
    return {
      aligned_sequences: [sequences[0]],
      consensus: sequences[0],
      total_score: 0,
    }
  }

  let original_center = sequences[0]
  let aligned = [original_center]
  let mut total_score = 0

  for idx = 1; idx < sequences.length(); idx = idx + 1 {
    let pairwise = needleman_wunsch(
      original_center,
      sequences[idx],
      match_score,
      mismatch_score,
      gap_penalty,
    )
    total_score = total_score + pairwise.score

    let current_center = aligned[0]
    let pair_center = pairwise.alignment_a
    let pair_sequence = pairwise.alignment_b

    let merged_existing = Array::make(aligned.length(), "")
    let mut merged_new = ""
    let mut current_index = 0
    let mut pair_index = 0

    while current_index < current_center.length() ||
          pair_index < pair_center.length() {
      if current_index < current_center.length() &&
        pair_index < pair_center.length() {
        let current_char = current_center[current_index]
        let pair_char = pair_center[pair_index]
        if current_char != '-' && pair_char != '-' {
          append_column(merged_existing, aligned, current_index)
          merged_new = merged_new +
            pair_sequence[pair_index].to_int().unsafe_to_char().to_string()
          current_index = current_index + 1
          pair_index = pair_index + 1
          continue
        }
        if current_char == '-' && pair_char == '-' {
          append_column(merged_existing, aligned, current_index)
          merged_new = merged_new + "-"
          current_index = current_index + 1
          pair_index = pair_index + 1
          continue
        }
        if current_char == '-' {
          append_column(merged_existing, aligned, current_index)
          merged_new = merged_new + "-"
          current_index = current_index + 1
          continue
        }

        append_gap_column(merged_existing)
        merged_new = merged_new +
          pair_sequence[pair_index].to_int().unsafe_to_char().to_string()
        pair_index = pair_index + 1
        continue
      }

      if current_index < current_center.length() {
        append_column(merged_existing, aligned, current_index)
        merged_new = merged_new + "-"
        current_index = current_index + 1
      } else {
        append_gap_column(merged_existing)
        merged_new = merged_new +
          pair_sequence[pair_index].to_int().unsafe_to_char().to_string()
        pair_index = pair_index + 1
      }
    }

    for i = 0; i < aligned.length(); i = i + 1 {
      aligned[i] = merged_existing[i]
    }
    aligned.push(merged_new)
  }

  {
    aligned_sequences: aligned,
    consensus: build_consensus(aligned),
    total_score,
  }
}

///|
pub fn progressive_msa(
  sequences : Array[String],
  match_score : Int,
  mismatch_score : Int,
  gap_penalty : Int,
) -> Array[String] {
  progressive_msa_result(sequences, match_score, mismatch_score, gap_penalty).aligned_sequences
}
