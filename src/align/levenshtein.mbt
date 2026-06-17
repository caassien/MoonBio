pub fn min(a: Int, b: Int) -> Int {
  if a < b { a } else { b }
}

pub fn levenshtein_distance(s1: String, s2: String) -> Int {
  let m = s1.length()
  let n = s2.length()
  if m == 0 { return n }
  if n == 0 { return m }
  
  let prev = Array::make(n + 1, 0)
  let curr = Array::make(n + 1, 0)
  
  for j = 0; j <= n; j = j + 1 {
    prev[j] = j
  }
  
  for i = 1; i <= m; i = i + 1 {
    curr[0] = i
    for j = 1; j <= n; j = j + 1 {
      let cost = if s1[i - 1] == s2[j - 1] { 0 } else { 1 }
      curr[j] = min(curr[j - 1] + 1, min(prev[j] + 1, prev[j - 1] + cost))
    }
    for j = 0; j <= n; j = j + 1 {
      prev[j] = curr[j]
    }
  }
  return prev[n]
}
