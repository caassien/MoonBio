# Acceptance Notes

MoonBio 的验收入口统一使用 `scripts/verify_acceptance.ps1`。

## 本地建议顺序

1. `moon version --all`
2. `moon update`
3. `moon fmt --check`
4. `moon check --target all`
5. `moon test --target wasm`
6. `moon test --target wasm-gc`
7. `moon test --target js`
8. 有编译器时执行 `moon test --target native`
9. `moon info`
10. `git diff --exit-code`
11. `powershell -ExecutionPolicy Bypass -File .\scripts\check_repo_compliance.ps1`

## 重点风险

- GitLink 默认分支与 GitHub 默认分支尚未完全统一。
- 若需要 Mooncakes 最终发布，必须再次确认当前登录身份与模块所有者一致。
