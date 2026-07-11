# MoonBio 对照官方要求与预验收反馈

本文档根据 2026 年 7 月 11 日重新核对的 MoonBit OSC2026 官方页面与组委会预验收反馈整理，目的是把规则转成可执行的仓库检查项。

## 官方公开要求

- 赛事官网当前写明项目申报阶段为 `2026-04-29` 到 `2026-07-12`。
- 申报材料需要包含参赛信息、在线仓库链接和一页 PDF 项目申报书。
- 官网强调项目需围绕公开仓库持续开发，提交记录、工单、合并请求和更新日志应可追踪。
- 官网强调项目应真实可用、可测试、可维护。
- 官网将有效 MoonBit 代码规模描述为参考范围 `4~10k LOC`。
- 项目验收阶段时间为 `2026-07-13` 到 `2026-07-17`。

## 组委会预验收反馈拆解

1. 修复 `moon fmt --deny-warn`、`moon info --deny-warn` 直接失败的问题。  
   处理方式：当前 MoonBit `0.10.3` 下这两个命令并不支持 `--deny-warn`，仓库统一改为兼容现行工具链的 `moon fmt --check` 与 `moon info` 验证流程，并在 CI 和脚本中固定。

2. CI 补齐 `moon check`、`moon fmt --deny-warn`、`moon info --deny-warn`、`moon test`。  
   处理方式：按 MoonBit 社区 workflow 模板思路重做 CI，固定 MoonBit `0.10.3`，执行 `moon update`、`moon fmt --check`、`moon check --target all`、`moon test` 多目标、自查脚本与 `moon info`。

3. 补充申报书承诺的完整 MSA、真实 WASM/前端演示和可靠 FASTA/FASTQ 处理。  
   处理方式：补强 `src/align/msa.mbt`、`src/parser/*`、`cmd/wasm/*`、`cmd/cli/*`，并补充示例与文档。

4. 扩大有效源码和测试覆盖；当前规模偏小，测试偏基础。  
   处理方式：移除无意义占位实现，替换为实际可复用 API，并新增解析、MSA、引擎层测试与验收脚本。

5. 补充正确性、性能和使用示例证据。  
   处理方式：增加 `docs/usage-evidence.md`、README 运行说明、验收脚本和仓库合规脚本。

## MoonBio 当前执行清单

- `README`、`LICENSE`、申报书、自查文档齐备。
- GitHub Actions CI 已存在且覆盖格式化、检查、测试、接口生成。
- `moon.mod` / `moon.pkg` 已迁移到新格式。
- 解析、比对、MSA、CLI、WASM 入口均有对应源码和测试。
- 增加仓库结构、默认分支、提交历史、MoonBit 源码规模检查脚本。
