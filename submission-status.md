# Submission Status

更新日期：2026-08-12

## 本轮本地整改状态

- [x] 兼容 MoonBit 0.10.3；`cmd/cli` 和 `cmd/wasm` 使用 `options(is_main: true)`，不依赖 0.10.4 才有的包配置键。
- [x] 保留并强化 GitHub Actions CI：MoonBit 安装、依赖更新、全目标检查、测试、格式化、接口生成和合规脚本。
- [x] 扩充 `src/sequence`：IUPAC、窗口统计、突变分类、共识、ORF、翻译、限制性位点和低复杂度处理。
- [x] 扩充 `src/parser`：FASTA/FASTQ 边界、N50、长度直方图、重复 ID、碱基组成和 N 比例。
- [x] 扩充 `src/align`：CIGAR、identity、编辑距离、比对摘要、评分和参考坐标映射。
- [x] 扩充 `src/quality`：Phred 分布、逐位画像、窗口画像、trimming、过滤、逐读报告和 pass mask。
- [x] 增加 `src/benchmark` 和 `docs/data/`，使用 NCBI accession 可追溯的离线参考窗口。
- [x] 增加真实边界测试、负例测试、质量测试和确定性基准断言。
- [x] 实现代码达到 3500 行以上；验收脚本同时报告实现行数和含测试总行数。
- [x] README、许可证、来源说明、使用说明、基准说明和官方要求映射已同步更新。
- [ ] 本轮尚未推送 GitHub、GitLink 或 Mooncakes；等待用户后续明确发布指令。

## 当前本地审计口径

- 工作分支：`main`（本轮只做本地修改）。
- 工具链目标：MoonBit `0.10.3`。
- 远程写操作：无；本轮不会执行 `git push` 或 `moon publish`。
- 作者身份：后续若用户要求提交或推送，必须先核对 GitHub/GitLink/Mooncakes 登录身份和提交邮箱。

## 验收入口

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify_acceptance.ps1
```

详细证据见 [docs/usage-evidence.md](docs/usage-evidence.md)，基准和来源见 [docs/benchmarks.md](docs/benchmarks.md) 与 [source-attribution.md](source-attribution.md)。
