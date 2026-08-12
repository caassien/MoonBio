///|
fn compare_text(left : String, right : String) -> Int {
  let limit = if left.length() < right.length() {
    left.length()
  } else {
    right.length()
  }
  for i = 0; i < limit; i = i + 1 {
    if left[i] < right[i] {
      return -1
    }
    if left[i] > right[i] {
      return 1
    }
  }
  if left.length() < right.length() {
    -1
  } else if left.length() > right.length() {
    1
  } else {
    0
  }
}

///|
fn insert_kmer_sorted(counts : Array[KmerCount], kmer : String) -> Unit {
  for i = 0; i < counts.length(); i = i + 1 {
    if counts[i].kmer == kmer {
      counts[i] = { kmer, count: counts[i].count + 1 }
      return
    }
  }
  let item = { kmer, count: 1 }
  let mut position = counts.length()
  for i = 0; i < counts.length(); i = i + 1 {
    if compare_text(kmer, counts[i].kmer) < 0 {
      position = i
      break
    }
  }
  counts.push(item)
  let mut i = counts.length() - 1
  while i > position {
    let swap = counts[i - 1]
    counts[i - 1] = counts[i]
    counts[i] = swap
    i = i - 1
  }
}

///|
pub fn kmer_counts(
  sequence : String,
  k : Int,
) -> Result[Array[KmerCount], String] {
  if k < 1 {
    return Err("k-mer size must be positive")
  }
  match compact_iupac(sequence) {
    Err(err) => Err(err)
    Ok(compact) => {
      if compact.length() < k {
        return Err("k-mer size exceeds sequence length")
      }
      let counts = []
      for i = 0; i <= compact.length() - k; i = i + 1 {
        insert_kmer_sorted(counts, compact[i:i + k].to_owned())
      }
      Ok(counts)
    }
  }
}

///|
pub fn kmer_count(sequence : String, kmer : String) -> Result[Int, String] {
  if kmer.length() == 0 {
    return Err("k-mer query must not be empty")
  }
  match kmer_counts(sequence, kmer.length()) {
    Err(err) => Err(err)
    Ok(counts) => {
      for item in counts {
        if item.kmer == kmer {
          return Ok(item.count)
        }
      }
      Ok(0)
    }
  }
}

///|
pub fn total_kmers(sequence : String, k : Int) -> Result[Int, String] {
  match kmer_counts(sequence, k) {
    Err(err) => Err(err)
    Ok(counts) => {
      let mut total = 0
      for item in counts {
        total = total + item.count
      }
      Ok(total)
    }
  }
}
