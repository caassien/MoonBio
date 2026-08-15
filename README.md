# MoonBio

[![CI](https://github.com/caassien/MoonBio/actions/workflows/ci.yml/badge.svg)](https://github.com/caassien/MoonBio/actions/workflows/ci.yml)

MoonBio 是面向 MoonBit 生态的可复用生物信息学基础库。项目覆盖 DNA/RNA 序列处理、FASTA/FASTQ 解析、经典序列比对、渐进式 MSA、质量控制、限制性位点分析、WASM/CLI 示例，以及离线可复现的基准报告。

当前主仓库：[GitHub](https://github.com/caassien/MoonBio)；镜像仓库：[GitLink](https://gitlink.org.cn/cassien/MoonBio)。项目使用 MIT License，默认开发分支为 `main`。

## 项目范围

- 为序列分析提供明确、无网络依赖的纯 MoonBit API。
- 对真实格式输入给出可定位的错误信息，而不是静默丢弃坏记录。
- 用边界测试、真实来源的短参考窗口和确定性指标支撑验收与回归。
- 保持 CLI、WASM 和库 API 都能在 MoonBit 0.10.3 工具链上构建。

本项目不是完整的 BLAST、生产级短读长比对器或浏览器产品。当前重点是可读、可测试、可扩展的高性能生物信息学基础能力。

## 功能概览

- `src/core`：核苷酸类型、反向互补、转录和 HMM Viterbi 示例。
- `src/parser`：多记录 FASTA/FASTQ 解析、格式校验、GC/Phred 统计、N50、长度直方图、重复 ID 与碱基组成检查。
- `src/sequence`：IUPAC 规范化、碱基统计、k-mer、motif、Hamming、ORF、翻译、共识序列、突变分类、低复杂度屏蔽、限制性内切酶位点与消化片段。
- `src/align`：Needleman-Wunsch、Smith-Waterman、Levenshtein、渐进式 MSA、CIGAR、比对摘要、编辑距离、identity 和参考坐标映射。
- `src/quality`：Phred 解码、逐位质量画像、滑动窗口、末端 trimming、FASTQ 汇总、逐读质量报告和过滤统计。
- `src/benchmark`：使用 NCBI 可追溯参考窗口和固定 FASTQ fixture 的离线确定性基准报告。
- `cmd/cli`：可直接运行的全局比对、MSA、解析统计和基准示例。
- `cmd/wasm`：真实 WASM 构建入口与导出示例函数。

## 仓库结构

```text
.
├── .github/workflows/ci.yml
├── cmd/cli/                 # CLI demo
├── cmd/wasm/                # WASM demo
├── docs/data/               # 可追溯、离线 fixture
├── scripts/                 # 合规检查和验收入口
├── src/core/
├── src/parser/
├── src/sequence/
├── src/align/
├── src/quality/
├── src/benchmark/
├── moon.mod
├── moon.pkg
├── LICENSE
├── official-requirements.md
├── proposal-one-page.md
├── source-attribution.md
└── submission-status.md
```

## 快速开始

需要 MoonBit 工具链 `0.10.3+16975d007`（`moonc v0.10.3`）。CI 使用同一固定构建，并校验官方社区归档的 SHA-256；本地安装可使用 MoonBit 官方安装器安装 0.10.3。

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

若本机有 C 编译器，可额外执行：

```bash
moon test --target native
```

运行 CLI：

```bash
moon run cmd/cli
```

构建 WASM：

```bash
moon build --target wasm-gc cmd/wasm
```

## 基准与真实 fixture

```powershell
moon test src/benchmark --target wasm
```

fixture 位于 `docs/data/`：

- `reference_sequences.fasta`：HBB `NM_000518.5` 和 lacZ 区域 `J01636.1` 的前 140 个碱基窗口。
- `reference_reads.fastq`：由上述参考窗口构造的固定回归读长，包含高质量、变异和低质量记录。

来源、截取范围、许可证边界和预期指标见 [docs/benchmarks.md](docs/benchmarks.md) 与 [source-attribution.md](source-attribution.md)。测试不访问网络，便于 CI 和离线验收复现。

## 本地验收

推荐执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify_acceptance.ps1
```

仓库合规检查也可以单独执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check_repo_compliance.ps1
```

检查包括格式、全目标静态检查、WASM/JS/wasm-gc/native 测试、接口生成、README/LICENSE/CI、提交历史、远程默认分支和 MoonBit 实现规模。脚本分别报告“实现文件行数”和“含测试的总行数”，当前实现代码硬性目标为至少 3500 行。

## 文档

- [官方要求映射](official-requirements.md)
- [验收状态](submission-status.md)
- [使用与验证证据](docs/usage-evidence.md)
- [正确性与基准](docs/benchmarks.md)
- [来源与开源合规](source-attribution.md)
- [一页项目说明](proposal-one-page.md)
- [变更日志](CHANGELOG.md)

## License

MIT License，详见 [LICENSE](LICENSE)。
