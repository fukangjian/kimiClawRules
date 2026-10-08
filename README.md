# kimiClawRules

用途：备份和迁移 OpenClaw/Kimi 交易规则系统。

包含：
- 长期规则与纪律：`MEMORY.md`
- 规则迁移包：`exports/rules/`
- 每日分析/复盘：`memory/*.md`、`daily_report*`、`daily-reports/`、`daily_report/`
- 备份脚本：`scripts/backup_rules.sh`
- 系统人格/行为文件：`AGENTS.md`、`SOUL.md`、`IDENTITY.md`

不包含：本地上传下载、密钥、运行缓存、个人通讯录、环境特定工具细节。

导入到新系统时：优先读取 `exports/rules/RULES_EXPORT.md`，再按 `exports/rules/manifest.json` 校验完整性；若新系统支持目录结构，可直接使用本仓库根目录。
