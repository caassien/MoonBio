# MoonBio 正确性与性能基准

本文档给出不依赖外部数据库的最小可复现实验。它用于比较工具链或提交之间的
变化，不把某一台机器的绝对耗时当作性能承诺。

## 正确性边界

- FASTA：多记录、跨行序列、CRLF、缺少头部、空记录和非法字符。
- FASTQ：多记录、质量长度一致性、缺少 `@`/`+`、空序列和质量范围。
- 比对：空序列、完全相同、完全不同、插入缺口和局部匹配。
- MSA：零条、单条、不同长度和多条序列；结果要求所有行等宽。

运行完整测试：

```powershell
moon test --target wasm
moon test --target wasm-gc
moon test --target js
```

## 性能模型

Needleman-Wunsch 与 Smith-Waterman 都使用二维动态规划矩阵，输入长度为 `m`、`n`
时为 `O(m*n)` 时间和 `O(m*n)` 空间。渐进式 MSA 依次将每条序列与中心序列比对，
因此主要计算量约为 `O(k*m*n)`，其中 `k` 是序列条数。FASTA/FASTQ 解析按输入长度
线性扫描。

CLI 演示可用于冒烟计时：

```powershell
Measure-Command { moon run cmd/cli }
```

提交前请记录工具链版本（`moon version --all`）、目标后端、输入规模和操作系统，
再比较 `TotalMilliseconds`；这样结果可审计且不会把构建缓存误当成算法速度。
