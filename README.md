# MoonBio

![CI](https://github.com/caassien/cassien/actions/workflows/ci.yml/badge.svg)

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
moon install
moon test
```

### Usage Example

You can run the built-in CLI example to see the Needleman-Wunsch alignment algorithm in action:

```bash
moon run cmd/cli
```

**Output:**
```
MoonBio CLI Engine v0.1.0 started.
Alignment Score: 0
Seq 1: G-ATTACA
Seq 2: GCA-TGCU
```

### Using in your project

Add the dependency to your `moon.pkg.json`:

```json
{
  "import": ["cassien/moonbio/src/align"]
}
```

```moonbit
fn main {
  let res = @align.needleman_wunsch("GATTACA", "GCATGCU", 1, -1, -1)
  
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
