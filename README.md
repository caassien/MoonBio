# MoonBio

MoonBio is a lightweight bioinformatics library for MoonBit. It provides basic data structures and alignment algorithms to process DNA/RNA sequences, primarily targeting WASM environments.

## Features

- **Sequence Ops**: Basic types and operations for DNA/RNA (e.g., reverse complement, transcription).
- **Parsers**: A simple zero-allocation FASTA file reader.
- **Alignment Algorithms**:
  - Needleman-Wunsch (Global)
  - Smith-Waterman (Local)
  - Levenshtein Distance

## Quick Start

```bash
git clone https://github.com/caassien/cassien.git
cd cassien
moon test
```

### Usage Example

```moonbit
import cassien/moonbio/align

fn main {
  // simple needleman-wunsch alignment
  let res = align.needleman_wunsch("GATTACA", "GCATGCU", 1, -1, -1)
  
  println(res.score)
  println(res.alignment_a)
  println(res.alignment_b)
}
```

## TODO / Roadmap
- FASTQ parsing
- MSA (Multiple Sequence Alignment)
- HMM-based motif discovery

## License
MIT
