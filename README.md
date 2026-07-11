# 奶龙工具箱 NaiLong Toolbox

基于 Flutter 开发的多功能本地工具箱 App，目标平台：Android / Web / Windows / iOS。

- 状态管理：Riverpod
- 路由：go_router
- 本地存储：shared_preferences（收藏、历史、主题、语言）
- 所有工具默认离线运行，不上传任何文件或输入内容（IP 查询等极少数工具除外，页面上会明确标注"需要联网"）
- UI：Material 3 + 轻量"液态玻璃"（毛玻璃）质感，支持浅色 / 深色 / 跟随系统
- 多语言：简体中文 / 繁体中文 / English

当前已实现 **47 个工具**（图片 8 个、文本 13 个、随机 8 个、日期与计算 9 个、网络与开发 9 个），
详见文末"已实现 / 待补充功能清单"。

---

## 一、这是什么、还缺什么

这份代码是完整的 Flutter **源代码工程**（`lib/` 目录 + `pubspec.yaml`），但是：

> ⚠️ 这个压缩包里**没有** `android/`、`ios/`、`web/`、`windows/` 这些平台工程目录。
> 因为这些目录体积很大、且是可以用命令自动生成的"样板代码"，所以没有包含在内。
> 你需要在**你自己的电脑上**执行一条命令来自动生成它们（见下面"第一步"），非常简单。

这是所有 Flutter 项目分享源码时的标准做法，不用担心。

---

## 二、环境准备（你的 Windows 10 电脑）

你已经装好了 Android Studio，很好，还需要：

1. **安装 Flutter SDK**
   - 打开 https://docs.flutter.dev/get-started/install/windows ，下载 Flutter SDK 压缩包
   - 解压到一个**没有中文、没有空格**的路径，例如 `D:\flutter`
   - 把 `D:\flutter\bin` 添加到系统环境变量 `Path` 中
   - 打开一个新的 PowerShell / CMD，输入 `flutter --version` 能看到版本号即成功

2. **运行体检命令**，根据提示补全缺失项（比如 Android SDK license 没同意等）：
   ```powershell
   flutter doctor
   ```

3. 在 Android Studio 里安装 **Flutter** 和 **Dart** 插件（Settings → Plugins → 搜索安装），
   这样才能在 Android Studio 里直接打开和运行 Flutter 项目。

---

## 三、第一次运行项目

1. 解压本压缩包，得到 `nailong_toolbox` 文件夹，用命令行 `cd` 进去。

2. **生成平台工程目录**（关键一步，只需要做一次）：
   ```powershell
   flutter create --platforms=android,web,windows .
   ```
   这条命令会在当前目录里补全 `android/`、`web/`、`windows/` 文件夹，
   并且**不会**覆盖已经写好的 `lib/`、`pubspec.yaml`。
   （`ios/` 因为要在 Windows 上编译没有意义，放到后面用 GitHub Actions 生成）

3. **拉取依赖包**：
   ```powershell
   flutter pub get
   ```
   如果某个包报版本冲突，把报错里提示的包版本按提示调整一下，或告诉我报错信息，我来帮你改。

4. **用手机跑起来看看**：
   - 用数据线连接你的 Android 手机，手机上打开"开发者选项 → USB 调试"
   - 命令行输入 `flutter devices` 应该能看到你的手机
   - 运行：
     ```powershell
     flutter run
     ```
   - 也可以直接在 Android Studio 里点顶部工具栏的绿色三角形 ▶ 运行

5. **在浏览器里跑起来看看**：
   ```powershell
   flutter run -d chrome
   ```

6. **在 Windows 桌面跑起来看看**：
   ```powershell
   flutter config --enable-windows-desktop
   flutter run -d windows
   ```

---

## 四、正式打包

### Android APK（自己安装用）
```powershell
flutter build apk --release
```
生成的文件在 `build\app\outputs\flutter-apk\app-release.apk`，直接传到手机上安装即可
（需要在手机设置里允许"安装未知来源应用"）。

### Web 静态网站
```powershell
flutter build web
```
生成的文件在 `build\web\`，可以直接丢到你已有的服务器 / 域名下用 Nginx 或任意静态网站托管方式部署。

### Windows 桌面 exe
```powershell
flutter build windows
```
生成的文件在 `build\windows\x64\runner\Release\`，把整个 `Release` 文件夹拷走就能在别的 Windows 电脑上运行
（需要附带该文件夹里的所有 dll）。

### iOS（用 GitHub Actions 云编译 + 自己签名安装）

你的思路是对的，完全可行，步骤如下：

1. 把整个项目推送到你的 GitHub 仓库（记得也把 `.github/workflows/ios-build.yml` 一起推上去，
   压缩包里已经帮你写好了这个文件）。
2. 打开仓库的 **Actions** 标签页，找到 "Build Unsigned iOS IPA"，点击 **Run workflow** 手动触发。
   （GitHub 会用免费的 macOS 云端虚拟机帮你编译，大约几分钟）
3. 编译完成后，在该次运行的页面底部 **Artifacts** 里下载 `NaiLongToolbox-unsigned-ipa`，
   解压得到一个未签名的 `.ipa` 文件。
4. 用下面任意一种方式，用你自己的 Apple ID 重新签名并安装到 iPhone：
   - **推荐**：[Sideloadly](https://sideloadly.io/)（Windows/Mac 都支持）：连接 iPhone，
     拖入 `.ipa`，登录你的 Apple ID，点击开始，几分钟就能装到手机上。免费 Apple ID 签名的 App
     每 7 天需要重新签一次，Apple 开发者账号（$99/年）签名可以用 1 年。
   - 或者用 **AltStore**：先在电脑装 AltServer，手机装 AltStore，之后可以直接在手机上导入 ipa。
   - 如果你有 Mac，也可以直接用 Xcode 打开 `ios/Runner.xcworkspace`，选择你的 Apple ID 作为
     "Personal Team"，直接 Run 到手机上，比处理 ipa 更省事。

> 首次在 GitHub Actions 里生成 `ios/` 目录后，建议 `git pull` 到本地一份，方便以后本地也能看到 iOS 工程结构。

---

## 五、项目结构说明

```
lib/
  main.dart                    # 入口：初始化本地存储、启动 App
  app.dart                     # MaterialApp 配置：主题、语言、路由
  core/
    theme/                     # Material3 + 液态玻璃主题
    router/                    # go_router 路由表
    storage/                   # SharedPreferences 封装
    providers/                 # Riverpod 状态：主题、语言、收藏、历史
    models/                    # ToolInfo 等数据模型
    data/tool_registry.dart    # ⭐ 全部工具的注册表，新增工具在这里登记
    widgets/                   # 通用组件：工具页脚手架、结果操作栏、玻璃卡片
    l10n/                      # 自定义多语言字典（三语言）
    utils/                     # 各类工具函数（文件保存、图片处理、简繁转换表等）
  features/
    home/                      # 首页（分类网格）、底部导航壳
    search/ favorites/ history/ settings/ onboarding/
    tools/
      image/ text/ random/ datecalc/ dev/   # 47 个工具页面，按分类分文件夹
```

### 如何自己新增一个工具

1. 在 `lib/features/tools/<分类>/` 下新建一个 `xxx_screen.dart`，
   参考同目录下任意一个已有文件的写法（用 `ToolPageScaffold` 包裹，用 `ResultActionsBar` 展示结果操作）。
2. 在 `lib/core/l10n/app_translations.dart` 的三个语言字典里，加一个 `titleKey` 对应的中/繁/英文名称。
3. 在 `lib/core/data/tool_registry.dart` 顶部 import 这个新文件，并在列表里加一行 `ToolInfo(...)`。
4. 完成！首页分类、搜索、收藏、历史都会自动出现这个新工具，不需要改任何其他地方。

---

## 六、已实现 / 待补充功能清单

### ✅ 已完整实现（47 个）
- **图片工具（8）**：图片转 Base64、Base64 转图片、图片压缩、格式转换（PNG/JPG/BMP）、
  尺寸调整、旋转、转黑白、二维码生成
- **文本工具（13）**：字数统计、文本去重、文本排序、大小写转换、简繁转换、文本加密解密（AES）、
  URL 编解码、Base64 文本编解码、JSON 格式化、JSON 压缩、Markdown 预览、随机密码生成、UUID 生成
- **随机工具（8）**：随机数、随机字符串、随机颜色、随机抽签、随机分组、随机选择器、抛硬币、掷骰子
- **日期与计算（9）**：时间戳转换、日期间隔、年龄计算、倒计时、单位换算、BMI、百分比计算、
  进制转换、普通计算器
- **网络与开发（9）**：IP 查看（唯一需联网）、设备信息、正则测试、哈希计算、JWT 解析、
  HTML/CSS/XML 格式化、Cron 表达式生成

### 🚧 暂未实现，建议下一步补充（原需求里的剩余 5 个图片工具）
- 图片裁剪（需要交互式裁剪框 UI）
- 图片加水印（文字/图片水印叠加）
- 图片颜色提取（取色器 + 色板）
- 图片信息查看（EXIF、尺寸、格式等元数据展示）
- 二维码识别（拍照/选图识别二维码内容，涉及额外的原生插件，Windows/Web 支持有限）

这 5 个工具的架构和其他图片工具完全一致（同样是"选图 → 处理 → 预览 → 保存/分享"的模式），
补充起来很快，可以直接找我继续写。

### 已知的简化处理（不影响使用，但可以知道一下）
- **简繁转换**：内置约 300+ 常用汉字对照表做本地转换，不是完整的 OpenCC 词库，
  生僻字或"一简对多繁"的词组级转换可能不完全准确。
- **HTML / CSS 格式化**：是基于规则的轻量格式化，不是完整的语法解析器，
  适合快速美化代码，特别复杂/不规范的代码可能处理不完美。
- **IP 地址查看**：是全 App 里少数需要联网的工具之一（因为公网 IP 本来就要靠远程服务查询），
  页面上已经明确标注"需要联网"。
- 图片处理已经用 `compute()` 放到后台线程执行，避免处理大图时界面卡顿，但暂未做超大图片
  （几十 MB 以上）的专门内存优化。

---

## 七、隐私说明

除"IP 地址查看"这一个工具外，其余全部工具的所有处理都在你的设备本地完成，
不会把你选择的图片、输入的文本发送到任何服务器。收藏、历史、主题、语言等设置也只保存在本机
（`shared_preferences`），没有账号系统，没有云同步。

---

## 八、遇到编译报错怎么办

因为这份代码是在没有 Flutter 环境的沙盒里写好的，没办法在这边直接跑 `flutter pub get` /
`flutter build` 做实际编译验证。代码经过了仔细检查（依赖是否用到、import 是否正确、
API 是否存在等），但如果你在 `flutter pub get` 或运行时遇到报错，把**完整的报错信息**发给我，
我可以根据具体报错快速定位并修复，通常都是很小的版本兼容问题。

---

## 九、本轮更新修复了什么

你上一条消息贴的日志其实是 GitHub Actions **任务收尾阶段**的日志（`git config` 清理、
Node.js 版本提示），并不是真正报错的那部分，所以从里面看不出具体是哪一步、哪一行代码失败的。
不过没关系，我做了这些修复和加固：

1. **修掉了一个潜在的编译期小隐患**：`uuid` 生成工具里 `Uuid()` 实例之前声明成了
   `static const`，但这个包的构造函数不一定支持 `const` 用法，已改成更保险的 `static final`，
   不影响任何功能，纯粹是让代码更稳。
2. **把 iOS 构建工作流改得更健壮、更好排查问题**（`.github/workflows/ios-build.yml`）：
   - 不再写死 Flutter 版本号，直接拉最新稳定版，避免版本号过期/写错导致下载失败
   - 单独跑 `pod repo update && pod install --verbose`，如果是 CocoaPods 依赖解析出问题，
     日志会更清楚地指出来，而不是被淹没在 `flutter build` 的输出里
   - 自动把 `ios/Podfile` 里的最低系统版本设置为 iOS 13.0，避免个别插件要求更高版本导致冲突
   - 自动给 `Info.plist` 补上相册访问权限说明文案（后续用到选图功能时，没有这个文案 App 在
     真机上会直接崩溃，这是很多人第一次打包 iOS App 时会踩的坑）
   - **无论构建成功还是失败，都会把完整构建日志作为 Artifact 上传**（名字叫 `ios-build-log`），
     以后再失败，直接在 Actions 页面下载这个日志文件发给我就行，不用再手动复制网页上的文字

### 如果这次重新运行还是失败了，请这样做
1. 打开失败的那次 Actions 运行记录
2. 往下滑到页面底部 **Artifacts** 区域，下载 `ios-build-log`（一个纯文本 `.log` 文件）
3. 打开这个文件，搜索关键字 `error:`，把附近的十几行贴给我（或者整个文件发给我也行）

有了这份日志，我才能看到 Xcode / CocoaPods 真正报出来的错误信息，帮你精确定位并修复问题——
盲改代码去猜错误原因效率比较低，希望你理解。

### 第三轮修复（CocoaPods "No Podfile found"）
`flutter create` 生成的 iOS 工程默认**不包含** `Podfile`（较新版本 Flutter 改成了按需生成），
而我上一版加的"单独跑 `pod install`"步骤跑得太早，那时候 `Podfile` 还不存在，所以报错。
现在改成先用 `flutter build ios --config-only` 专门生成 Podfile / Xcode 配置文件（不做完整编译），
确认 Podfile 存在之后，再去做我们自己的修改（最低系统版本、Info.plist 权限说明）和 `pod install`，
最后才执行真正的完整构建。相册权限说明文案也从中文改成了英文，避免个别 shell 环境下的编码问题。

### 第四轮修复（根本原因：Flutter 已从 CocoaPods 转向 Swift Package Manager）
这次是真正找到根源了：从 **Flutter 3.44** 版本开始，iOS/macOS 的原生依赖管理默认已经从
CocoaPods 换成了 **Swift Package Manager（SPM）**，CocoaPods 进入"维护模式"。我们的工作流
拉取的是"最新稳定版" Flutter，大概率已经是这个新版本，所以根本不会再生成 `ios/Podfile`
这个文件——前几轮围绕"生成/修改 Podfile"做的所有操作，都建立在过时的假设上。

现在的做法是：**完全不再手动插手 CocoaPods/Podfile**，只保留跟依赖管理机制无关的 Info.plist
权限文案补丁，其余全部交给 `flutter build ios` 自己处理（不管它内部实际用的是 SPM 还是
CocoaPods，`flutter build` 都会自动识别并正确处理）。这是官方支持的标准路径，也是最不容易
因为 Flutter 工具链自身演进而出问题的做法。

### 关于"适配不同品牌设备"的说明
- **Android**：不同厂商（小米/华为/OPPO/vivo 等）对后台任务、权限弹窗有各自的定制，
  但本 App 的图片处理都在前台同步完成、不需要后台权限，风险很低。用到网络请求的"IP 地址查看"
  工具依赖标准 `INTERNET` 权限，`flutter create` 生成的 `AndroidManifest.xml` 默认就带有此权限，
  一般不需要手动改动。
- **iOS**：不同 iOS 版本对隐私权限描述文案的要求不同，这次已经在 CI 里自动补上了相册权限说明；
  如果之后新增拍照类工具（比如二维码扫描），还需要额外补充 `NSCameraUsageDescription`，
  到时候我会一并处理。
- **Windows / Web**：保存文件的逻辑已经做了平台判断（Windows/桌面端优先存到"下载"目录，
  拿不到就退回 App 数据目录；Web 端直接触发浏览器下载），不依赖任何厂商定制行为。

---

祝你开发顺利！有任何想继续添加的功能、想调整的界面细节，随时告诉我。

