# 01: 本地化 Ruby 脚本模板

**What to build:** 为 Ruby 模板增加英文和中文字符串目录，并让项目元数据与示例界面跟随 Development Kit 语言显示。

**Blocked by:** None

**Status:** resolved
**Type:** task

- [x] 增加英文与中文 BCP 47 字符串目录，提供项目描述和界面文案。
- [x] 入口 Ruby 脚本使用 `$stringResources` 获取计数标签、按钮文本和语言标识。
- [x] 在按钮下方显示本地化的 `Ruby` 语言名称。
- [x] 中文目录覆盖项目名称，英文目录保留 `appName` 配置回退值。
- [x] README 说明字符串目录和 Ruby 全局变量 API。
- [x] 使用 `rerunRuby` 在指定设备验证英文、中文 UI 与语言标识。

## Answer

Ruby 模板已提供英文和中文字符串目录，项目描述、计数标签、按钮和语言标识均从 `$stringResources` 获取。Development Kit 恢复跟随系统语言。`rerunRuby` 在设备 `192.168.31.207` 的英文与中文 locale 下均成功；两种 UI 的本地化文案和语言标识均已确认。未运行静态检查。
