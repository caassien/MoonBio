fn max4(a: Int, b: Int, c: Int, d: Int) -> Int {
  let mut max = a
  if b > max { max = b }
  if c > max { max = c }
  if d > max { max = d }
  max
}

pub fn smith_waterman(s1: String, s2: String, match_score: Int, mismatch_score: Int, gap_penalty: Int) -> AlignmentResult {
  let m = s1.length()
  let n = s2.length()
  
  let score_matrix = Array::make(m + 1, [])
  for i = 0; i <= m; i = i + 1 {
    score_matrix[i] = Array::make(n + 1, 0)
  }
  
  let mut max_score = 0
  let mut max_i = 0
  let mut max_j = 0
  
  for i = 1; i <= m; i = i + 1 {
    for j = 1; j <= n; j = j + 1 {
      let match_cost = if s1[i - 1] == s2[j - 1] { match_score } else { mismatch_score }
      let diag = score_matrix[i - 1][j - 1] + match_cost
      let up = score_matrix[i - 1][j] + gap_penalty
      let left = score_matrix[i][j - 1] + gap_penalty
      let current_score = max4(0, diag, up, left)
      score_matrix[i][j] = current_score
      
      if current_score > max_score {
        max_score = current_score
        max_i = i
        max_j = j
      }
    }
  }
  
  let align_a = []
  let align_b = []
  let mut i = max_i
  let mut j = max_j
  
  while i > 0 && j > 0 && score_matrix[i][j] > 0 {
    let match_cost = if s1[i - 1] == s2[j - 1] { match_score } else { mismatch_score }
    if score_matrix[i][j] == score_matrix[i - 1][j - 1] + match_cost {
      align_a.push(s1[i - 1])
      align_b.push(s2[j - 1])
      i = i - 1
      j = j - 1
      continue
    }
    if score_matrix[i][j] == score_matrix[i - 1][j] + gap_penalty {
      align_a.push(s1[i - 1])
      align_b.push('-')
      i = i - 1
      continue
    }
    if score_matrix[i][j] == score_matrix[i][j - 1] + gap_penalty {
      align_a.push('-')
      align_b.push(s2[j - 1])
      j = j - 1
    }
  }
  
  let mut final_a = ""
  let mut final_b = ""
  for idx = align_a.length() - 1; idx >= 0; idx = idx - 1 {
    final_a = final_a + String::make(1, align_a[idx].to_int().unsafe_to_char())
    final_b = final_b + String::make(1, align_b[idx].to_int().unsafe_to_char())
  }
  
  { score: max_score, alignment_a: final_a, alignment_b: final_b }
}
