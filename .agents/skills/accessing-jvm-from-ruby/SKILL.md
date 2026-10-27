---
name: accessing-jvm-from-ruby
description: 从 M8Test JRuby 脚本访问 JVM 类型、调用成员、传递 Proc 或使用宿主 wrappers 时使用。
---

# 从 Ruby 访问 JVM

按当前 JRuby 模板的代理规则访问 JVM 类型；先确认依赖已加载到脚本 classloader。Ruby 语法能表达调用不代表所有 overload 或返回类型都能正确转换。公共 wrapper 语义见 `using-host-values-and-wrappers`。

```ruby
builder = Java::JavaLang::StringBuilder.new("M8Test")
builder.append(" Ruby")
raise "StringBuilder" unless builder.toString == "M8Test Ruby"

raw = $arrays.intArrayOf(3, 1, 2)
values = $objectWrappers.wrapIntArray(raw)
values.set(0, 7)
raise "wrapper" unless values.getSize == 3 && values.contains(7)
```

Ruby `Integer`、`Float`、`nil`、`Array` 与 JVM primitive、boxed、nullable、数组和集合按 JRuby 与目标签名转换。Proc 可作 callback 时单独验证参数、返回与执行时机。修改示例时更新 Ruby JVM interop fixture 并验证目标运行时。
