# Usage Evidence

本文档记录 MoonBio 当前用于验收的运行方式与关键证据点。

## 1. 代码格式与静态检查

```powershell
moon fmt --check
moon check --target all
```

目的：

- 验证仓库格式一致。
- 验证多目标静态检查通过。

## 2. 测试

```powershell
moon test --target wasm
moon test --target wasm-gc
moon test --target js
```

本地若存在 C 编译器：

```powershell
moon test --target native
```

当前测试覆盖：

- DNA 解析、转录、反向互补
- HMM Viterbi 示例
- Needleman-Wunsch / Smith-Waterman / Levenshtein
- 渐进式 MSA 结果长度一致性
- FASTA / FASTQ 解析与统计
- 引擎层整合调用

## 3. CLI 示例

```powershell
moon run cmd/cli
```

预期可观察到：

- 全局比对得分与对齐结果
- MSA 共识序列
- FASTA / FASTQ 统计摘要

## 4. WASM 构建

```powershell
moon build --target wasm-gc cmd/wasm
```

当前产物：

- `_build/wasm-gc/debug/build/cmd/wasm/wasm.wasm`

当前导出入口源码位于：

- `cmd/wasm/main.mbt`

## 5. 仓库自查

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check_repo_compliance.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\verify_acceptance.ps1
```

检查项包括：

- README / LICENSE / CI / 申报书 / 自查文档
- 当前分支、提交数量、远程默认分支
- 有效 MoonBit 文件数量与行数
- `moon info`、`git diff --exit-code`

## 6. Mooncakes 发布验证

```powershell
moon whoami
moon publish --dry-run
moon publish
```

当前已确认：

- 登录身份为 `caassien`
- `caassien/moonbio@0.1.1` 已成功发布
