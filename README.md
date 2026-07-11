# MoonBio

[![CI](https://github.com/caassien/MoonBio/actions/workflows/ci.yml/badge.svg)](https://github.com/caassien/MoonBio/actions/workflows/ci.yml)

MoonBio 是一个面向 MoonBit 生态的生物信息学基础库，聚焦序列解析、经典比对算法、简单 MSA 流程、CLI/WASM 演示与可复现验收流程。仓库按 2026 MoonBit OSC2026 的公开开发要求整理，当前主仓库为 [GitHub](https://github.com/caassien/MoonBio)，镜像仓库为 [GitLink](https://gitlink.org.cn/cassien/MoonBio)。

## 目标

- 提供可复用的 DNA/RNA 序列基础能力。
- 提供 MoonBit 可运行的 FASTA / FASTQ 解析实现。
- 提供 Needleman-Wunsch、Smith-Waterman、Levenshtein 和渐进式 MSA。
- 提供可验证的 CLI 与 WASM 构建入口。
- 提供竞赛验收需要的 CI、自查脚本、来源说明和申报材料。

## 功能概览

- `src/core`
  - DNA 序列类型、反向互补、转录、HMM Viterbi 示例。
- `src/parser`
  - 多记录 FASTA 解析。
  - FASTQ 解析与质量长度一致性校验。
  - FASTA / FASTQ 汇总统计。
- `src/align`
  - Needleman-Wunsch 全局比对。
  - Smith-Waterman 局部比对。
  - Levenshtein 距离。
  - 基于中心序列的渐进式 MSA。
- `cmd/cli`
  - 运行全局比对、MSA 和解析统计示例。
- `cmd/wasm`
  - 生成 WASM 入口并导出示例函数。

## 仓库结构

```text
.
├── cmd/
│   ├── cli/
│   └── wasm/
├── docs/
├── scripts/
├── src/
│   ├── align/
│   ├── core/
│   └── parser/
├── moon.mod
├── moon.pkg
├── official-requirements.md
├── proposal-one-page.md
├── source-attribution.md
└── submission-status.md
```

## 快速开始

```bash
git clone https://github.com/caassien/MoonBio.git
cd MoonBio
moon update
moon fmt --check
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon test --target js
```

本机若安装了 C 编译器，还可以继续执行：

```bash
moon test --target native
```

## 示例

CLI 示例：

```bash
moon run cmd/cli
```

WASM 构建：

```bash
moon build --target wasm-gc cmd/wasm
```

产物默认位于：

```text
_build/wasm-gc/debug/build/cmd/wasm/wasm.wasm
```

## 验收与自查

- 官方要求映射见 [official-requirements.md](official-requirements.md)
- 当前整改状态见 [submission-status.md](submission-status.md)
- 代码来源说明见 [source-attribution.md](source-attribution.md)
- 使用和验证证据见 [docs/usage-evidence.md](docs/usage-evidence.md)
- 一键自查脚本见 [scripts/verify_acceptance.ps1](scripts/verify_acceptance.ps1)

推荐本地执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify_acceptance.ps1
```

若需要强制验证 native 目标：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify_acceptance.ps1 -RequireNative
```

## MoonBit 包信息

- Module: `caassien/moonbio`
- License: `MIT`
- 推荐工具链：`moonc v0.10.3`

## 当前限制

- `cmd/wasm` 已提供真实 WASM 构建入口与导出函数，但浏览器侧展示页仍以轻量验收演示为主，后续可以继续扩展为完整交互式前端。
- 当前 MSA 为可运行的渐进式基线版本，重点在可测试、可维护和可扩展。

## License

MIT
