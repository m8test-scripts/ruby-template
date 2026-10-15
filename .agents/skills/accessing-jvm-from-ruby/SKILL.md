---
name: accessing-jvm-from-ruby
description: 当 Ruby 脚本需要访问 JVM 类、调用 Java/Kotlin 成员或传递函数 callback 时使用。
---

# 从 Ruby 访问 JVM

Ruby 模板使用 JRuby。JVM 类访问遵循 JRuby Java integration；全局变量使用 Ruby 的 $ 名称。先确认目标类名在当前 JRuby classloader 中可见，再照搬 JRuby 的 package 约定。

## 类与对象

```ruby
builder = Java::JavaLang::StringBuilder.new("M8Test")
builder.append(" Ruby")
raise "StringBuilder" unless builder.toString == "M8Test Ruby"
```

先确认依赖已加载到当前脚本 classloader。声明文件或代码补全存在不等于运行时类可见。方法重载、静态字段、嵌套类、异常等边界按目标语言的生成代码和实际设备行为验证。

## 函数 callback

Ruby block 与 Proc 可用于 callback 参数。非末尾 callback 可用 lambda；注意明确返回值，按真实宿主 API 签名验证。

## 函数 callback 示例

Ruby Proc 可以按目标 Kotlin 函数类型传入 callback。模板 Test Control 通过 Logger.withContext 实际验证 callback 被调用并获得参数：

```ruby
called = false
$logger.withContext(lambda { |context| called = !context.nil? })
raise "callback" unless called
```

## 类型转换边界

Ruby Integer、Float、String、nil、Array 与 JVM primitive、boxed、nullable、数组、集合的映射取决于 JRuby 和目标签名；不要仅凭语法相似性推断。

逐项记录已测试的 primitive/boxed、字符串、nullable、数组、集合、varargs、重载和异常行为。未经执行验证的转换写为待验证，不根据其他脚本语言推断。

## 验证

本模板的 ruby-template-jvm-interop Test Control 场景会实际调用 JVM StringBuilder，并验证宿主数组工厂和 wrapper。运行当前项目支持的选中 Test Control 任务并检查 summary 中该 requestId 为 passed；若当前模板没有注册相应任务，使用模板设备运行任务并确认成功日志。Gradle 使用 -q。
