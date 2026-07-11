# Submission Status

更新日期：2026-07-11

## 针对预验收意见的整改状态

- [x] 统一到 MoonBit `0.10.3` 兼容命令集
- [x] 重做 GitHub Actions CI
- [x] 补强 FASTA / FASTQ 解析与统计
- [x] 补强渐进式 MSA
- [x] 补充 CLI / WASM 演示入口
- [x] 补充 README、来源说明、官方要求映射、自查脚本
- [x] 补充解析器、MSA、引擎层测试
- [ ] GitLink 默认分支与 GitHub 默认分支完全统一
- [x] Mooncakes 身份链路复核完成
- [x] Mooncakes `0.1.1` 正式发布

## 当前已确认状态

- GitHub 仓库默认分支：`main`
- GitLink 远程当前 `HEAD` 仍指向：`master`
- 本地当前工作分支：`main`
- MoonBit 工具链：`moonc v0.10.3`
- Mooncakes 当前登录身份：`caassien`
- `0.1.0` 已存在于 Mooncakes，整改版本需使用新版本号发布
- Mooncakes 已成功发布版本：`caassien/moonbio@0.1.1`

## 下一步收尾

1. 跑完整自查脚本与 `moon publish --dry-run`。
2. 同步 GitHub / GitLink 最新提交。
3. 如果 GitLink 页面仍将默认分支指向 `master`，在网页设置中切换为 `main`。
