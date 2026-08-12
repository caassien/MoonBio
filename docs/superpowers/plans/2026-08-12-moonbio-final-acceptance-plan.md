# MoonBio Final Acceptance Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add substantive sequence, quality, benchmark, parser, alignment, documentation, and audit improvements while keeping the repository locally verifiable and above 3500 effective MoonBit source lines.

**Architecture:** Keep the existing root facade and package boundaries. Add pure `sequence`, `quality`, and `benchmark` packages; extend parser/alignment through public, tested APIs; use embedded reference fixtures so tests remain offline and deterministic.

**Tech Stack:** MoonBit 0.10.3, Moon package manifests, GitHub Actions-compatible commands, PowerShell audit scripts, Markdown documentation.

---

### Task 1: Sequence analysis package

**Files:**
- Create: `src/sequence/moon.pkg`
- Create: `src/sequence/types.mbt`
- Create: `src/sequence/validation.mbt`
- Create: `src/sequence/statistics.mbt`
- Create: `src/sequence/kmer.mbt`
- Create: `src/sequence/motif.mbt`
- Create: `src/sequence/orf.mbt`
- Create: `src/sequence/translation.mbt`
- Test: `src/sequence/sequence_test.mbt`

- [ ] Write failing tests for IUPAC validation, counts, GC, k-mers, motifs, ORFs, transcription, and translation.
- [ ] Run `moon test src/sequence --target wasm` and confirm the new symbols are missing.
- [ ] Implement the smallest package-local APIs and helpers.
- [ ] Run the package tests on wasm, wasm-gc, and js; refactor only after green.

### Task 2: Quality analysis package

**Files:**
- Create: `src/quality/moon.pkg`
- Create: `src/quality/types.mbt`
- Create: `src/quality/phred.mbt`
- Create: `src/quality/filter.mbt`
- Create: `src/quality/windows.mbt`
- Test: `src/quality/quality_test.mbt`

- [ ] Write failing tests for Phred conversion, distributions, low-quality windows, trimming, and filter summaries.
- [ ] Run the package tests and verify the expected missing API failures.
- [ ] Implement deterministic quality metrics and threshold validation.
- [ ] Run all supported targets and inspect generated interfaces.

### Task 3: Benchmark fixture and reporting package

**Files:**
- Create: `src/benchmark/moon.pkg`
- Create: `src/benchmark/dataset.mbt`
- Create: `src/benchmark/report.mbt`
- Create: `src/benchmark/scenarios.mbt`
- Test: `src/benchmark/benchmark_test.mbt`
- Create: `docs/data/reference_sequences.fasta`
- Create: `docs/data/reference_reads.fastq`

- [ ] Write failing tests for fixture counts, deterministic reports, and scenario summaries.
- [ ] Run tests to confirm missing benchmark APIs fail.
- [ ] Add source-attributed, short offline fixtures and reporting code.
- [ ] Run the benchmark tests and compare expected counts.

### Task 4: Parser and alignment depth

**Files:**
- Modify: `src/parser/fasta.mbt`, `src/parser/fastq.mbt`
- Modify: `src/parser/parser_test.mbt`
- Modify: `src/align/nw.mbt`, `src/align/sw.mbt`, `src/align/align_test.mbt`
- Create: `src/align/path.mbt`

- [ ] Add failing tests for parser filtering and alignment path summaries.
- [ ] Verify red status before implementation.
- [ ] Implement bounded filtering and CIGAR/edit summaries without changing existing results.
- [ ] Run regression tests on all supported targets.

### Task 5: Facade, CLI, documentation, and audit

**Files:**
- Modify: `moon.pkg`, `pkg.generated.mbti`, `README.md`
- Modify: `cmd/cli/main.mbt`
- Modify: `docs/benchmarks.md`, `docs/usage-evidence.md`, `source-attribution.md`
- Modify: `scripts/check_repo_compliance.ps1`, `scripts/verify_acceptance.ps1`

- [ ] Add an end-to-end CLI scenario using the benchmark fixture summaries.
- [ ] Document APIs, data provenance, complexity, reproducibility, license boundaries, and limitations.
- [ ] Make the audit script report `.mbt` implementation LOC, package count, tests, and required artifacts.
- [ ] Run fmt, check, info, tests, build, CLI, audit, and clean-tree checks.

### Task 6: Local handoff

- [ ] Run `moon fmt --check`, `moon check --target all`, all target tests, `moon info`, and both PowerShell audits.
- [ ] Confirm effective `.mbt` source lines exceed 3500 and no generated/build artifacts are tracked.
- [ ] Review `git diff`, commit locally with author `cassien <caassien@users.noreply.github.com>`, and do not push.
