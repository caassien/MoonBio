# Source Attribution

## 开发原则

- 仓库中的 MoonBit 代码以本项目目标为中心维护，重点是生物序列解析、比对算法、MSA 基线实现、CLI/WASM 演示与验收自动化。
- 当前仓库不直接复制第三方项目的整段源码，也不引入未标注来源的粘贴式实现。
- 算法实现基于公开通用思路独立整理，包括：
  - Needleman-Wunsch 全局比对
  - Smith-Waterman 局部比对
  - Levenshtein 编辑距离
  - Viterbi 动态规划
  - 基于中心序列的渐进式 MSA

## 参考材料

- MoonBit 官方工具链与 workflow 模板思路
- 生物信息学基础算法公开教材与常见动态规划定义
- FASTA / FASTQ 常见文件格式约定

## 需要持续说明的部分

- `src/align/msa.mbt` 当前实现是面向竞赛验收的可运行基线版本，后续可以继续扩展为 profile-profile 或 guide tree 驱动的更完整 MSA。
- `cmd/wasm` 当前重点是提供真实 WASM 构建入口与导出函数，而不是完整浏览器产品化页面。
