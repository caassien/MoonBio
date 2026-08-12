# MoonBio 对照官方要求与预验收反馈

本文档把 OSC2026 公开要求和组委会预验收意见转成仓库内可执行的检查项。规则原文和赛程可能更新，最终以组委会通知和官方页面为准。

## 验收关注点

1. 项目要有清晰范围、持续提交记录、可读 README、许可证和使用说明。
2. MoonBit 源码必须是项目主体，能够在当前工具链下格式化、检查和测试。
3. 功能应有实际应用价值，不能只有演示壳；应覆盖正常输入、异常输入和边界行为。
4. CI 应能在干净环境复现检查，避免依赖本机缓存或手工步骤。
5. 引用的代码、数据和第三方材料必须有来源和许可证说明。
6. 性能定位要有复杂度模型和可复现基准，不能只写未经条件说明的单机耗时。

## 对预验收意见的整改映射

### `moon.pkg` 与格式检查

本仓库按 MoonBit 0.10.3 兼容语法维护。当前验收命令使用：

```powershell
moon fmt --check
moon check --target all
moon info
```

如果评测环境提供了不同版本，应先确认该版本支持的命令和包配置键；不能把其他版本的配置缓存直接复制到本仓库。

### CI

`.github/workflows/ci.yml` 固定安装 MoonBit 0.10.3，覆盖 Ubuntu、macOS、Windows，执行依赖更新、全目标检查、测试、格式化 diff、接口生成和合规脚本。工作流使用 `persist-credentials: false`，不把推送权限注入构建任务。

### 功能深度

- FASTA/FASTQ：多记录、跨行、CRLF、非法头、非法字符、质量长度、N50、直方图、组成和重复 ID。
- 序列：IUPAC、k-mer、motif、GC 窗口、翻译、ORF、共识、突变类型、限制性位点和低复杂度屏蔽。
- 比对：全局/局部/编辑距离、MSA、CIGAR、identity、评分、编辑摘要和坐标映射。
- 质量：Phred 分布、逐位/逐窗口画像、trimming、过滤、错误风险分桶和逐读报告。
- 基准：NCBI accession 可追溯的短参考窗口与固定 FASTQ，离线运行。

### 文档与合规

README 给出项目范围、结构、命令、数据和限制；`LICENSE` 为 MIT；`source-attribution.md` 记录算法、数据来源和边界；`docs/usage-evidence.md` 给出复制即用的验收命令；`scripts/check_repo_compliance.ps1` 检查关键文件、CI、提交、默认分支和源码规模。

## 本地最终检查

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify_acceptance.ps1
```

本轮只做本地实现，不代表已经向任何远程仓库推送或向 Mooncakes 发布。
