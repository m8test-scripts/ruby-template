# [M8Test](https://dev-docs.m8test.com) Ruby Gradle 模板

> 如有疑问，请加入我们的官方 QQ 群：[749248182](https://qm.qq.com/q/jVVADJCAI8) 或 QQ
> 频道：[m8testofficial](https://pd.qq.com/s/8pidhywcy)

---

## 📦 Gradle 任务说明

### 任务分组

1. **`m8test-build`**  
   M8Test构建相关任务组，包含`buildRuby`（构建Ruby项目）、`runRuby`（运行项目）等任务。

2. **`m8test-code-completion`**  
   M8Test代码补全相关任务组，包含`generateRubyAllCodeCompletionFiles` （生成所有需要的代码补全文件）,
   `generateRubyGlobalVariables`（生成全局变量代码补全文件）等任务。

3. **`m8test-developmenet-environment`**  
   M8Test开发环境相关任务组，包含`installDevelopmentEnvironment`（安装开发环境）、`installRubyPlugin`（安装语言插件）等任务。

4. **`m8test-download`**  
   M8Test资源下载相关任务组，包含`downloadRubyCodeTemplate`（下载示例代码模板）、`downloadRubyDocs`（下载文档）等任务。

> 实际开发中主要关注构建任务和代码补全任务即可。

### 常用任务

| 任务名称                            | 任务分组                             | 功能描述                                                                                    |
|---------------------------------|----------------------------------|-----------------------------------------------------------------------------------------|
| `generateGroovyGlobalVariables` | `m8test-code-completion`         | 生成Groovy全局变量代码补全文件，提供IDE代码提示功能。需连接安卓设备，建议编写代码前执行一次，依赖更新后需重新执行。                          |
| `buildGroovy`                   | `m8test-build`                   | 构建M8Test Groovy脚本项目源码（不执行），构建结果位于`build/project`目录。                                     |
| `runGroovy`                     | `m8test-build`                   | 构建并将项目推送到已连接的安卓设备上运行。                                                                   |
| `buildGroovyApk`                | `m8test-build`                   | 将M8Test Groovy脚本项目打包成APK文件。                                                             |
| `installJRubyInterceptor`       | `m8test-development-environment` | 安装 JRuby 解析器。执行此任务会从网络下载 Ruby 并安装到 `~/.m8test/bin/jruby` 目录。若已安装 JRuby 解析器，执行此任务不会重新安装。 |

---

## 🚀 执行任务的方法

### 方法一：使用快捷搜索

1. 双击 `Ctrl` 键，打开搜索框。
2. 输入 `gradle 任务名`，例如 `gradle runRuby`，然后按回车执行。

   ![方法一示例](images/1.png)

### 方法二：通过 Gradle 面板

1. 点击 Gradle 图标。
2. 依次展开 `ruby` > `Tasks` > `m8test`。
3. 双击需要执行的任务。

   ![方法二示例](images/2.png)

### 方法三：使用终端命令

1. 按下快捷键 `Alt + F12` 打开终端。
2. 输入命令 `./gradlew 任务名`，例如 `./gradlew runRuby`，然后按回车执行。

   ![方法三示例](images/3.png)

---

## ⚙️ 配置脚本项目

脚本项目的配置位于 `ruby/build.gradle.kts` 文件中。您可以根据需要修改设备的 IP、ADB 端口等参数。该文件中包含详细的代码注释，供参考。

---

## 🛠️ 项目开发流程

1. **生成全局变量**  
   执行`generateGroovyGlobalVariables`任务生成代码补全文件，提供IDE代码提示功能。

2. **安装 Ruby 解析器**  
   执行 `installRubyInterceptor` 任务，安装 Ruby 解析器, 如果使用M8Test集成开发环境的话已经自带JRuby解析器, 此步骤可以跳过。

3. **配置 Ruby 解析器**

   如果项目没有配置ruby解析器就会出现下面的提示, 这时候可以点击 `configure` <br>

   ![](images/4.png)

   点击 `Project` > `Sdk 右边的输入框` > `Add Sdk` > `JRuby Sdk`

   ![](images/5.png)

   选择 `interceptor`

   ![](images/6.png)

   找到jruby.exe的路径后点击 `Ok`, 如果是集成开发环境则在 `C:\Users\Your username\.m8test\bin\jruby\jruby.exe`

   ![](images/7.png)

   可以看到jruby sdk成功添加, 点击`apply`

   ![](images/8.png)

   选择 `Modules` > `ruby` > `main` > `Module Sdk 右边的输入框` > `选择jruby sdk`

   ![](images/9.png)

   点击 `apply`

   ![](images/10.png)

   再点击添加按钮

   ![](images/11.png)

   选择 `JRuby`

   ![](images/12.png)

   可以看到jruby添加成功, 点击 `apply` > `Ok`

   ![](images/13.png)

   可以看到已经没有需要配置ruby解析器提示了

   ![](images/14.png)

   如果 require 提示 `No such file to load`

   ![](images/15.png)

   在 `Project` 视图中 `ruby/src/main/ruby` 目录下鼠标右键 > `Mark Directory as` > `Load Path Root`

   ![](images/16.png)

   等待一下 require 就正常了

   ![](images/17.png)

4. **连接日志服务**

   按下快捷键 `Alt + T`，依次选择 `M8Test` > `连接日志服务`。

5. **编写并运行脚本**

   编写代码并保存后，执行 `runRuby` 任务，即可在安卓设备上运行脚本项目。确保安卓设备已开启 ADB 调试。运行日志可在
   M8Test 日志面板中查看。

6. **打包Apk**  
   所有的脚本开发工作都完整后, 如果你需要打包成独立的apk可以执行 `buildRubyApk` 任务。

## APK 启动策略

应用身份在 `projectConfig` 中设置：`name` 是显示名称，`packageName` 是唯一包名，`versionName` 与 `versionCode` 控制版本，`logo` 指向 `res` 下的图标。构建生成的脚本配置会将这些值应用到 APK。`appName`、`appVersionName` 和 `appVersionCode` Gradle 属性可覆盖名称和版本。默认安装后自动运行脚本。需要由用户点击运行时，在语言配置块中选择手动启动：

```kotlin
m8testRuby {
    apkBuild {
        launchMode = "manual"
    }
}
```

`launchMode` 只接受 `"automatic"` 或 `"manual"`。手动模式显示启动页，由用户决定何时运行。
## 发布签名

APK 默认使用开发签名。发布时在 `m8testRuby { apkBuild { ... } }` 中设置 `signingMode = "release"`、密钥库路径和别名，并通过 `providers.environmentVariable("M8TEST_RELEASE_STORE_PASSWORD")` 与 `providers.environmentVariable("M8TEST_RELEASE_KEY_PASSWORD")` 提供密码。发布 APK 在本机签名并验证，输出到 `build/apk/`。密钥库和密码不会进入生成源码或设备项目；缺少发布签名配置时构建会失败。请把密钥库保存在受控位置并排除在版本控制之外，JDK `keytool` 可用于生成、导入和导出密钥材料。
