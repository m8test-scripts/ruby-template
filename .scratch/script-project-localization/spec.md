# Ruby 模板脚本项目 i18n

Status: complete
Triage: ready-for-human

## Problem Statement

Ruby 模板入口 UI 使用固定中文文案，也没有标出当前界面来自 Ruby 模板。项目缺少英文/中文字符串目录范例，复制模板的开发者无法直接使用宿主 locale 驱动的脚本本地化。

## Solution

为 Ruby 模板添加英文和中文 BCP 47 字符串目录；入口 Compose UI 从 `$stringResources` 获取计数文本、按钮和按钮下方的语言标识。目录同时提供本地化项目描述，中文目录覆盖项目名称。README 说明资源目录、Ruby 全局变量 API 和 locale 行为。

## Implementation Decisions

- 本次范围只包括 Ruby 模板仓库；宿主的 locale 匹配与 fallback 逻辑不变。
- Ruby 语言全局变量名称为 `$stringResources`。
- 字符串目录位于 `ruby/res/strings/`，文件名使用 `en.json` 和 `zh.json`。
- 英文 catalog 提供描述和完整 UI 文案，但不覆盖项目名称；中文 catalog 提供本地化项目名称、描述和 UI 文案。
- Ruby 专名保持 `Ruby`；语言标识是完整静态字符串，由 catalog 提供。
- 在 192.168.31.207 上用 `rerunRuby` 验证英文和中文界面及语言标识。
- 不运行静态检查。

## Out of Scope

- 修改宿主、Gradle 插件、Ruby Extension 或其他模板仓库。
- 新增 locale 选择、格式化 API、插值机制或额外语言目录。

## Verification

- 在设备 `192.168.31.207` 上使用 `rerunRuby` 分别运行英文和 `zh-Hans-CN` locale；两次运行均成功。
- 检查了两种语言下的计数标签、按钮和 Ruby 语言标识。
- 未运行静态检查。
