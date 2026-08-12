# MoonBio Final Acceptance Expansion Design

## Goal

在不破坏现有 API 的前提下，把 MoonBio 扩展为可用于小型序列分析流程的 MoonBit
基础库：增加真实可复用的序列分析、测序质量、基准数据和验收证据，并让版本库中的
有效 `.mbt` 源码超过 3500 行。

## Acceptance interpretation

- README、许可证、使用说明、来源归属和 CI 必须能让评审者从干净环境复现结果。
- 功能扩展必须对应真实生物信息学任务，而不是仅增加占位代码或重复实现。
- 测试覆盖成功路径、空输入、非法输入、边界长度、歧义碱基、质量值异常和性能退化。
- 基准数据采用带来源/ accession 说明的短序列 fixture，避免网络依赖，测试结果可复现。
- 所有改动只在本地完成；本轮不推送 GitHub、GitLink 或 Mooncakes。

## Architecture

### `src/sequence`

纯字符串序列分析 API：IUPAC 碱基验证与规范化、碱基统计、GC/AT 指标、k-mer 计数、
模糊 motif 搜索、Hamming 距离、开放阅读框扫描、RNA 转录和标准遗传密码子翻译。
该包不依赖 IO，适合 WASM、CLI 和其他包复用。

### `src/quality`

FASTQ 质量分析 API：Phred+33 解码、质量分布、N 分数、低质量窗口、trim 建议、
过滤摘要和多记录汇总。输入通过现有 parser 校验，输出包含可审计的计数和阈值。

### `src/benchmark`

内置小型参考数据集和基准报告 API，覆盖短 DNA、含突变序列、蛋白编码片段和
FASTQ 质量样本。报告记录输入规模、算法名称、结果摘要和复杂度，不依赖系统时间或网络。

### Existing packages

- `src/parser`：补充批量记录过滤、空白/注释处理边界和统计测试。
- `src/align`：补充一致性校验、编辑路径/CIGAR 摘要和算法基准接口。
- root/CLI/docs：接入新 API，提供端到端示例和验收矩阵。

## Error handling

公开函数优先返回 `Result[T, String]`；错误消息包含格式、位置和失败原因。对空输入、
非法 IUPAC 字符、不可整除的密码子、负阈值和超出窗口长度的参数显式拒绝或返回空结果，
不依赖 panic 作为正常控制流。

## Testing strategy

每个新行为先写一个最小失败测试，再实现最小通过版本。测试覆盖三类 MoonBit 后端
（wasm、wasm-gc、js），并在有 C 编译器时覆盖 native。基准 fixture 同时用于单元测试、
CLI 冒烟和文档中的复现实验。

## Documentation and compliance

README 增加 API 分类、真实 fixture 来源、复杂度和验收命令；`docs/benchmarks.md`
记录数据集、指标和运行方式；`source-attribution.md` 记录数据来源及许可证；自查脚本
统计 `.mbt` 实现文件、测试数量、文档和 CI 存在性。许可证继续使用 MIT，并明确第三方
数据只作为小型测试 fixture，保留来源链接和 accession。
