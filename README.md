# Lens controller 1.6.4

Lens controller 将 Android 掌机的内置或外接手柄映射为 Windows 上的独立虚拟手柄，支持 USB 有线、经典蓝牙 RFCOMM、Xbox 360、DualShock 4、自定义按键布局、触控板、掌机实时电量和震动反馈。

项目包含：

- `LensController-1.6.4.apk`：运行在 Android 掌机上的采集端。
- `LensController-1.6.4-Setup.exe`：Windows 图形控制面板、后台服务及安装/卸载程序。

蓝牙模式不会注册 Android 通用 HID 手柄。掌机通过 RFCOMM 把输入发送到 PC 配套程序，再由 ViGEmBus 创建虚拟手柄。

## 手柄布局

- Xbox 360 兼容布局。
- DualShock 4 布局。
- 最多可创建多个自定义布局。
- Xbox、DualShock 和自定义布局都支持逐项重新绑定物理按键。
- 支持通用 Android 手柄的 `BUTTON_1/2/4/5`、`BUTTON_7…15`、`Z/RZ`、`RX/RY`、`L2/R2`、`BRAKE/GAS`、`THROTTLE/RUDDER` 等常见轴布局。
- 支持摇杆死区、中心/行程校准、四轴反转和左右摇杆交换。

DualSense 布局及 DualSense 专属路径已在 1.6.0 中移除。旧版本保存的 DualSense 预设会在升级后自动清理，并回退到 Xbox 预设。

## 实时输入监测

- 应用启动时监测默认关闭。
- 未启用时，监测功能区会被模糊处理，中央显示“监测未启用，请选定并长按 X / 方形键进入”。
- 必须先选定监测功能区，再长按 X / 方形键进入监测。
- 无触摸模式下，“监测功能区已选中”和“长按 X / 方形键”必须同时满足；该逻辑与 1.6.2 一致。
- 触摸屏设备通过长按监测功能区切换监测开关。
- 长按 B / 圆形键退出监测的功能只在监测已启用时有效。
- 未启用监测时，手柄输入不会发送给 Windows，避免误操作。
- 退出监测后，监测区重新模糊并停用普通手柄输入。

## 选择光标与无触摸操作

- 使用十字键或左摇杆移动选择，两者使用同一套焦点逻辑。
- 左右方向优先在同一行选项间移动，只有越过左栏边界时才进入监测功能区。
- 上下方向可以选中屏幕外的设置项，并自动滚动左侧页面。
- 上下方向先进入最近的视觉行，再在该行内按水平距离选择，不会跳过全宽选项。
- 长按十字键或持续推动左摇杆会连续移动和滚动，松开后立即停止。
- 从屏保退出后会重新聚焦监测功能区；第一次按十字键即恢复光标。
- 普通选项左侧显示黑色、粗圆润的迷你十字形光标，不遮挡选项标题和主要内容。
- 选中整个监测功能区时，光标会放大并提高对比度。
- 无触摸掌机启动后直接进入手柄导航模式。
- A / 叉键确认，B / 圆形键参与返回和三连退出应用。
- 连续三次 B / 圆形键会提示并关闭 Lens controller。
- 对话框支持 A / 叉确认和 B / 圆形取消。

触摸屏设备采用普通触摸逻辑：单击选项立即生效，不再需要先聚焦、再按确认。

## 屏保

- 默认包含 12 张图片，支持全屏幻灯片。
- 可以从 Android 内部存储选择自定义图片。
- “一键默认”恢复全部内置图片。
- 切换间隔支持 2–60 秒。
- 循环模式支持全循环和随机循环。
- 触摸屏退出次数支持 3–20 次。
- 连接成功后自动进入屏保，也提供手动“进入屏保”按钮。
- 屏保期间窗口亮度调到最低，触控板功能继续工作。

### 屏保手柄退出

无触摸掌机在屏保中不能依赖触屏退出，因此必须先设置专用手柄退出方式：

- 按键可选 Start、Home / Mode、Select。
- 模式可选“连续按键”或“长按按键”。
- 连续按键支持 2–10 次。
- 长按支持 1–10 秒。
- 未完成设置时禁止进入屏保，并显示配置提示，防止无触摸掌机进入屏保后无法退出。

桥接成功进入屏保后，按键、摇杆、扳机和方向输入继续映射到电脑。只有已配置的屏保退出按键组合会被拦截，其他输入正常透传到 Windows。触摸屏设备仍可通过设定的轻触次数退出。

## 触控板

- 屏保期间整块掌机触摸屏作为触控板使用。
- 坐标映射为 DualShock 4 触控板的 `1920 × 943` 坐标。
- 支持双指触点、移动、按下和释放。
- 移动和点按分离：单次轻触只移动触点，不产生点击。
- 360ms 内连续轻触两次才产生一次触控板 click，避免拖动或单击误触。
- Xbox 布局不发送触控板数据；DualShock 4 和自定义 PlayStation 映射路径可用。

## 电量与震动

- Android 端每 30 秒刷新系统电池容量和充电状态。
- 电量通过数据包发送到 PC，并使用 Sony 报告的 0–10 档电量编码写入 DualShock 4 扩展报告。
- Windows 游戏触发虚拟手柄震动时，服务会把左右马达强度回传给掌机。
- Android 端可单独关闭掌机震动反馈。

## 性能

- 输入状态变化时立即发送，空闲状态每 250ms 发送心跳，避免蓝牙链路空闲休眠造成间歇停顿。
- 输入发送线程和蓝牙/USB 接收线程使用高优先级，屏保时停止刷新被遮挡的监测界面。
- Windows 端服务日志改为异步缓冲写入，避免按键状态写入日志时阻塞输入事件循环。
- Android 输入监测 UI 限制在约 30fps。
- 蓝牙 RFCOMM 使用独立反馈线程，避免震动回传阻塞输入接收。
- 蓝牙会优先连接已保存的掌机地址，减少每次重连扫描。
- 蓝牙断线使用递增退避，不会每 600ms 无限重建虚拟手柄。
- USB 与蓝牙只允许一个输入通道处于活动状态，避免两个通道重复创建手柄。
- Xbox 和 DualShock 4 的震动通知类型在服务进程内只注册一次，支持反复断开和重新桥接。
- Windows 控制面板只在服务状态或日志发生变化时刷新。

## Windows 安装

1. 运行 `LensController-1.6.4-Setup.exe`。
2. 选择安装目录。
3. 可选创建桌面快捷方式。
4. 可选启用 Windows 登录自启动。
5. 从桌面或开始菜单打开 Lens controller。

控制面板关闭窗口后留在系统托盘。后台服务通过隐藏窗口启动，不会显示 CMD 窗口。

> Windows 安装包当前未使用商业 Authenticode 证书签名，SmartScreen 可能在首次运行时显示未知发布者提示。APK 已使用项目本地发布密钥签名。

## 使用方法

### 蓝牙

1. 首次使用前，在 Windows 蓝牙设置中将掌机添加为配对设备。
2. 掌机蓝牙名称可在应用内修改，默认名称为 `Lens controller`。
3. 在 APK 中选择布局和“蓝牙”。
4. 点击“开始桥接”。
5. PC 服务优先连接已配对设备，并保存成功连接的地址。

### USB 有线

1. 使用数据线连接掌机和电脑。
2. 在掌机允许 USB 调试。
3. 启动 PC 控制面板。
4. 在 APK 中选择“USB 有线”并点击“开始桥接”。

程序优先建立 ADB 反向隧道；没有 USB 调试时，也可尝试 Android USB 网络共享。

## 数据与隐私

- PC 日志、最近连接的掌机名称和蓝牙地址保存在 `%LOCALAPPDATA%\LensController`。
- 软件不上传输入数据、屏保或设备名称。
- 卸载程序会停止后台进程，并清理安装目录、快捷方式、自启动项、日志、连接配置和本产品创建的防火墙规则。
- GitHub 源文件不包含 Android 签名私钥。

## 目录

```text
app/                         Android 应用源码
pc-bridge/                   Windows 服务、GUI 和虚拟手柄代码
installer/                   Inno Setup 安装脚本
branding/                    品牌资源
tools/                       构建和 GitHub 打包脚本
build-release.ps1            Android 测试、构建和签名
build-all.ps1                完整构建与发布整理
TEST-REPORT.md               测试记录
```

## 构建

环境要求：

- Windows 10/11 x64。
- JDK 21。
- Android SDK 35、Build Tools 35.0.0。
- Node.js 18 或更高版本。
- Inno Setup 6。

Android 发布签名不包含在源码包中。构建时通过参数或环境变量提供：

```powershell
cd pc-bridge
npm ci
cd ..
$env:LENS_KEYSTORE_PASSWORD = "你的签名密码"
.\build-release.ps1 -KeystorePath "D:\keys\release.jks" -KeyAlias "你的别名"
```

生成 Windows 安装包：

```powershell
.\tools\build-pc-installer.ps1
```

生成 GitHub 发布结构：

```powershell
.\tools\package-github.ps1
```

输出：

```text
publish/LensController-1.6.4-source/
publish/LensController-1.6.4-release/
publish/LensController-1.6.4-source.zip
publish/LensController-1.6.4-release.zip
```

## 故障排查

### Windows 没有出现虚拟手柄

- 确认 PC 控制面板显示“服务运行中”。
- 确认已经安装 ViGEmBus。
- 检查 Windows 是否阻止了 Node.js 或安装目录程序的网络访问。
- 如果启动时提示缺少组件，控制面板会列出具体缺失文件；关闭安全软件对 `runtime\node.exe`、`node_modules\koffi` 或 `native\ViGEmClient.dll` 的拦截后重新安装。
- 服务启动器的 stdout、stderr 和退出码会写入 `%LOCALAPPDATA%\LensController\service-launch.log` 与 `service-launch-error.log`。
- 缺少 ViGEmBus 驱动时，手动点击“启动服务”会请求管理员权限并尝试运行内置驱动修复脚本。

### 蓝牙无法连接

- 确认掌机与电脑仍保持配对。
- 删除旧配对记录后重新配对。
- 检查掌机蓝牙名称是否被修改。
- 确认没有旧版 Lens controller 服务占用 `47654` 端口。
- 断开后服务会逐步降低重试频率；等待数秒或重新点击开始桥接。

### 实时监测没有反应

- 先选中监测功能区，再长按 X / 方形键。
- 确认监测区已从模糊状态恢复。
- Xbox 布局没有触控板数据，请使用 DualShock 4 布局。

### 屏保退出后看不到光标

- 退出屏保后按一下十字键，光标会重新聚焦到监测功能区。
- 再长按 X / 方形键进入监测，输入才会发送至电脑。

### 屏保无法进入

- 打开“手柄退出”设置，选择按键和连续按键次数或长按时间。
- 未设置前禁止进入屏保是预期的防锁死保护。

## 第三方组件

Windows 虚拟手柄使用 ViGEmBus 和 ViGEmClient；Android 图片处理使用 Android 平台 API。相关第三方说明见 `pc-bridge/THIRD_PARTY_NOTICES.txt`。

`app/src/main/assets/screensaver` 中的默认图片由项目所有者提供；发布或再分发前请确认拥有相应的图片使用权。
