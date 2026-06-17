pub struct AlignmentResult {
  score: Int
  alignment_a: String
  alignment_b: String
}

fn max3(a: Int, b: Int, c: Int) -> Int {
  let mut max = a
  if b > max { max = b }
  if c > max { max = c }
  max
}

pub fn needleman_wunsch(s1: String, s2: String, match_score: Int, mismatch_score: Int, gap_penalty: Int) -> AlignmentResult {
  let m = s1.length()
  let n = s2.length()
  
  let score_matrix = Array::make(m + 1, [])
  for i = 0; i <= m; i = i + 1 {
    score_matrix[i] = Array::make(n + 1, 0)
  }
  
  for i = 0; i <= m; i = i + 1 {
    score_matrix[i][0] = i * gap_penalty
  }
  for j = 0; j <= n; j = j + 1 {
    score_matrix[0][j] = j * gap_penalty
  }
  
  for i = 1; i <= m; i = i + 1 {
    for j = 1; j <= n; j = j + 1 {
      let match_cost = if s1[i - 1] == s2[j - 1] { match_score } else { mismatch_score }
      let diag = score_matrix[i - 1][j - 1] + match_cost
      let up = score_matrix[i - 1][j] + gap_penalty
      let left = score_matrix[i][j - 1] + gap_penalty
      score_matrix[i][j] = max3(diag, up, left)
    }
  }
  
  let score = score_matrix[m][n]
  let align_a = []
  let align_b = []
  let mut i = m
  let mut j = n
  
  while i > 0 || j > 0 {
    if i > 0 && j > 0 {
      let match_cost = if s1[i - 1] == s2[j - 1] { match_score } else { mismatch_score }
      if score_matrix[i][j] == score_matrix[i - 1][j - 1] + match_cost {
        align_a.push(s1[i - 1])
        align_b.push(s2[j - 1])
        i = i - 1
        j = j - 1
        continue
      }
    }
    if i > 0 && score_matrix[i][j] == score_matrix[i - 1][j] + gap_penalty {
      align_a.push(s1[i - 1])
      align_b.push('-')
      i = i - 1
      continue
    }
    if j > 0 && score_matrix[i][j] == score_matrix[i][j - 1] + gap_penalty {
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
  
  { score, alignment_a: final_a, alignment_b: final_b }
}
