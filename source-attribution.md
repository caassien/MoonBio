# Source Attribution and Open-Source Compliance

## 代码来源

MoonBio 的 MoonBit 实现由本项目维护，未直接复制第三方仓库的整段源码。算法依据公开、通用的定义独立整理：

- Needleman–Wunsch 全局比对；
- Smith–Waterman 局部比对；
- Levenshtein 编辑距离；
- Viterbi 动态规划；
- 中心序列渐进式 MSA；
- FASTA/FASTQ、Phred+33、IUPAC 核苷酸约定。

实现、测试和文档均放在本仓库的 MIT License 范围内。代码没有引入需要单独再分发的第三方源码、二进制或模型权重。

## 参考数据来源

基准 fixture 是从公开 NCBI 记录中截取的短窗口，仓库只保存序列窗口，不声称拥有 NCBI 数据库的整体版权：

- [Homo sapiens HBB mRNA, RefSeq NM_000518.5](https://www.ncbi.nlm.nih.gov/nuccore/NM_000518.5)，保存 bases 1–140；
- [E. coli lactose operon, GenBank J01636.1](https://www.ncbi.nlm.nih.gov/nuccore/J01636.1)，保存 bases 1–140。

来源、版本、范围和本地文件映射记录在 [docs/benchmarks.md](docs/benchmarks.md)。固定 FASTQ 是由这些短窗口构造的回归 fixture，包含明确标注的高质量、变异和低质量记录，不冒充原始测序数据。

## 许可证

- 项目许可证：[MIT License](LICENSE)。
- 代码版权声明：`Copyright (c) 2026 caassien`。
- 基准 fixture 的使用范围限定为公开来源的短片段和测试用途；修改或重新分发时应保留来源、accession 和范围说明。

## 已知边界

- `src/align/msa.mbt` 是可运行、可测试的渐进式基线，不等同于 profile-profile 或 guide-tree MSA。
- `src/benchmark` 的性能报告是确定性功能回归，不是跨硬件的绝对吞吐承诺。
- `cmd/wasm` 提供真实构建入口和导出函数，尚未包装为完整浏览器前端产品。
