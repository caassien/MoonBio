# MoonBio 正确性与性能基准

本文档定义离线、确定性、可审计的回归基准。它用于比较提交前后的行为和算法规模，不把某一台机器的绝对耗时当成性能承诺。

## 运行环境

```powershell
moon version --all
moon fmt --check
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon test --target js
moon test src/benchmark --target wasm
```

基准数据不从网络下载，代码只读取仓库中的固定 fixture。若要记录耗时，应同时记录操作系统、CPU、MoonBit 版本、目标后端、输入记录数和输入碱基数。

## 参考数据

`docs/data/reference_sequences.fasta` 包含两个公开数据库参考窗口：

| fixture | 来源 | 范围 | 用途 |
| --- | --- | --- | --- |
| `HBB_NM_000518.5_window_1_140` | NCBI RefSeq `NM_000518.5` | bases 1–140 | 真核 mRNA 序列、GC、motif、比对 |
| `lacZ_J01636.1_window_1_140` | NCBI GenBank `J01636.1` | bases 1–140 | 细菌基因区域、GC、motif、k-mer |

`docs/data/reference_reads.fastq` 固定包含 4 条短读长，其中 3 条满足 Phred 平均质量阈值 20，1 条为低质量负例。该 fixture 用于验证质量汇总、过滤、逐位画像、N 统计和长度统计。

## 可验证结果

`run_benchmark("ATG")` 应满足：

- 参考序列数为 2，参考总长度大于 200；
- `ATG` 命中数大于 0；
- 平均 GC 百分比大于 0；
- 参考序列与去掉首碱基的自身序列比对 identity 大于 90%；
- FASTQ 总读数为 4，平均质量达到 20 的读数为 3。

这些断言在 `src/benchmark/benchmark_test.mbt` 中执行，不依赖网络和当前时间。

## 算法复杂度

| 模块 | 方法 | 时间 | 空间 | 说明 |
| --- | --- | --- | --- | --- |
| `src/parser` | FASTA/FASTQ 解析 | O(n) | O(n) | n 为输入字符数 |
| `src/align` | Needleman-Wunsch | O(mn) | O(mn) | 保存完整 DP 矩阵并回溯 |
| `src/align` | Smith-Waterman | O(mn) | O(mn) | 局部比对 |
| `src/align` | Levenshtein | O(mn) | O(n) | 两行滚动数组 |
| `src/align` | 渐进式 MSA | O(kmn) 基线 | 依实现 | 以首条序列为中心逐条合并 |
| `src/sequence` | k-mer/motif | O(n·k) 基线 | O(u) | u 为不同 k-mer 数 |
| `src/quality` | 逐位质量画像 | O(n) | O(L) | L 为最长读长 |

## 边界覆盖

- 空输入、空序列、缺失 FASTA 头、FASTQ 头/分隔行错误。
- CRLF、跨行 FASTA、非法字符、质量长度不一致、Phred 越界。
- k-mer、窗口、frame、阈值、长度范围和比对列的非法参数。
- 全相同、全不同、插入、缺失、错配、双 gap、空比对。
- N/IUPAC 模糊碱基、低复杂度连续碱基、重复 FASTA ID、N50 和长度直方图。

## 性能记录规范

记录 CLI 或库调用耗时前，请先执行一次预热构建，再使用相同输入重复至少 5 次；报告中保留中位数和输入规模。禁止把 `_build` 缓存命中、网络下载时间或不同后端结果混为一个数字。
