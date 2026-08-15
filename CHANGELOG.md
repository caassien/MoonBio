# Changelog

本文件记录 MoonBio 面向用户可见的功能、兼容性和验收基础设施变化。

项目遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/) 的组织方式，版本号遵循语义化版本约定。未发布内容统一记录在 `[Unreleased]`，发布时再移动到对应版本。

## [Unreleased]

### Added

- 增加可复现的离线基准 fixture，包括 HBB `NM_000518.5`、lacZ `J01636.1` 参考窗口和固定 FASTQ 读段。
- 增加序列 IUPAC 规范化、k-mer、motif、ORF/翻译、GC 窗口、突变分类、低复杂度屏蔽、共识序列、限制性位点和消化片段 API。
- 增加 FASTA/FASTQ 边界校验、N50、长度直方图、重复 ID、碱基组成和质量过滤报告。
- 增加 CIGAR、identity、编辑距离、比对摘要、评分和参考坐标映射 API。
- 增加 benchmark、CLI、WASM 示例以及 `verify_acceptance.ps1` 和 `check_repo_compliance.ps1` 验收入口。
- 增加 GitHub Actions 多平台 CI，固定 MoonBit `0.10.3+16975d007`，下载归档后执行 SHA-256 校验并缓存工具链。

### Changed

- 将项目验收目标明确为 MoonBit 0.10.3，并同步 README、使用证据、官方要求映射和 CI 配置。
- 将测试覆盖扩展到 WASM、WASM-GC、JS 以及可选的 native target。
- 将真实数据测试设计为离线确定性 fixture，避免 CI 因网络访问外部数据库而产生不可复现结果。

### Fixed

- 修复 GitHub Actions 使用 `hustcer/setup-moonbit@v1` 请求短版本 `0.10.3` 时因旧 CDN 路径返回 HTTP 403 导致 CI 在安装阶段中止的问题。
- 修复验收材料中项目规模、边界测试、性能基准和来源合规信息不完整的问题。

### Verification

- 本地 `moon fmt --check`、`moon check --target all` 和 WASM/WASM-GC/JS 测试通过。
- 本地 benchmark、CLI、WASM 构建和接口生成通过。

## [0.1.2] - 2026-08-06

### Added

- 发布 MoonBio 0.1.2，整理 Mooncakes 模块元数据、README、许可证和发布说明。
- 完成 GitHub Actions、Mooncakes 发布准备和 OSC2026 项目验收材料的第一轮整合。

## [0.1.1] - 2026-07-11

### Added

- 增加渐进式多序列比对、FASTA 统计、质量统计和可运行 CLI 示例。
- 补充项目 README、来源说明和 Mooncakes 0.1.1 发布材料。

## [0.1.0] - 2026-06-17

### Added

- 建立 MoonBio 项目结构和 MIT 许可证。
- 实现核苷酸类型、反向互补、转录、FASTA 读取和基础序列操作。
- 实现 Levenshtein、Needleman-Wunsch、Smith-Waterman 和 WASM 导出入口。
- 建立初版 GitHub Actions CI 和测试套件。

[Unreleased]: https://github.com/caassien/MoonBio/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/caassien/MoonBio/releases/tag/v0.1.2
[0.1.1]: https://github.com/caassien/MoonBio/releases/tag/v0.1.1
[0.1.0]: https://github.com/caassien/MoonBio/releases/tag/v0.1.0
