# Usage Evidence

本文档给出评委可以直接复制执行的本地验收路径。所有命令默认在仓库根目录执行，工具链为 MoonBit 0.10.3。

## 一键验收

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify_acceptance.ps1
```

脚本依次执行：版本确认、依赖更新、格式检查、全目标静态检查、多后端测试、接口生成、代码规模检查和工作树检查。无 C 编译器时 native 目标会明确说明跳过；使用 `-RequireNative` 时则会把缺失编译器视为失败。

## 分步命令

```powershell
moon version --all
moon update
moon fmt --check
moon check --target all
moon test --target wasm
moon test --target wasm-gc
moon test --target js
moon info
```

有 C 编译器时：

```powershell
moon test --target native
```

分包回归：

```powershell
moon test src/parser --target wasm
moon test src/sequence --target wasm
moon test src/align --target wasm
moon test src/quality --target wasm
moon test src/benchmark --target wasm
```

## 可见示例

```powershell
moon run cmd/cli
moon build --target wasm-gc cmd/wasm
```

CLI 会输出全局比对、MSA、FASTA/FASTQ 摘要和离线参考基准。WASM 入口在 `cmd/wasm/main.mbt`，构建产物通常位于 `_build/wasm-gc/debug/build/cmd/wasm/wasm.wasm`。

## 代码规模与合规

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\check_repo_compliance.ps1
```

该脚本只统计 Git 版本库中的 `.mbt` 文件，分别报告：

- 实现文件行数（排除 `_test.mbt`）；
- 含测试的总 MoonBit 行数；
- 包数量、测试文件数量、CI 和许可证；
- 当前分支、提交数和远程默认分支（只读检查）。

脚本将实现代码 3500 行作为硬性门槛，并检查 `docs/data/`、来源说明、README、LICENSE 和验收文档是否存在。

## 发布前检查

本轮任务只做本地实现，不执行推送、发布或身份切换。未来需要发布时，必须由仓库创建者确认登录身份后再单独执行：

```powershell
moon whoami
moon publish --dry-run
```
