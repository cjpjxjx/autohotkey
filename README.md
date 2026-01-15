# AutoHotkey 脚本集合

这是一个模块化的 AutoHotkey 脚本项目，通过主脚本统一管理多个功能模块，便于扩展和维护。

## 项目结构

```
autohotkey/
├── Main.ahk              # 主脚本入口（启动这个文件即可）
├── Reload.bat            # 脚本重载工具（修改配置后使用）
├── config.example.ahk    # 配置文件模板
├── config.ahk            # 个人配置文件（不会提交到 Git）
├── scripts/              # 功能脚本目录
│   └── FuckNumLock.ahk   # NumLock 相关功能
├── .gitignore            # Git 忽略文件配置
└── README.md             # 项目说明文档
```

## 快速开始

### 1. 首次使用配置

1. 复制 `config.example.ahk` 为 `config.ahk`
2. 编辑 `config.ahk`，修改其中的配置项为你的实际值
3. 双击运行 `Main.ahk`

### 2. 日常使用

只需双击运行 `Main.ahk`，所有启用的功能模块都会自动加载。

### 3. 重载配置

修改 `config.ahk` 配置文件后，双击运行 `Reload.bat` 即可重载脚本，使新配置生效。

## 当前功能模块

### NumLock 模块 (scripts/FuckNumLock.ahk)

**功能说明：**

1. **强制 NumLock 常亮** - 确保数字键盘始终处于数字输入模式
2. **双击 NumLock 快速输入** - 快速双击 NumLock 键（间隔小于 300 毫秒）可快速输入预设文本（在 config.ahk 中配置）
3. **小键盘数字映射** - 无论 NumLock 状态如何，小键盘都输出数字
4. **输入法智能切换** - 输入时自动切换到英文状态，完成后恢复原输入法状态
5. **OSD 提示** - 输入完成后可选显示屏幕提示（可在配置中开关）

**使用场景：**

- 快速输入常用密码或文本
- 在虚拟机控制台（PVE/VMware 等）中快速输入
- 确保小键盘始终可用于数字输入

## 添加新脚本模块

### 方法 1：创建新的脚本文件

1. 在 `scripts/` 目录下创建新的 `.ahk` 文件，例如 `MyNewScript.ahk`
2. 在文件开头添加 `#Requires AutoHotkey v2.0`
3. 编写你的脚本代码
4. 在 `Main.ahk` 中添加一行：`#Include scripts\MyNewScript.ahk`

### 方法 2：临时禁用某个模块

在 `Main.ahk` 中找到对应的 `#Include` 行，在前面添加分号 `;` 注释掉即可：

```ahk
; #Include scripts\FuckNumLock.ahk  ; 这样就禁用了该模块
```

## 配置说明

### config.ahk 配置项

```ahk
; NumLock 快速输入的文本
global NumLockInput := "your_password_here"

; 是否显示输入完成的 OSD 提示
global ShowOSDNotification := true

; 可以添加更多配置项
; global AnotherConfig := "some_value"
```

配置文件中的全局变量会在所有脚本模块中可用。

## 注意事项

1. **管理员权限**：主脚本会自动请求管理员权限，以确保在所有应用中正常工作
2. **单实例运行**：脚本会自动确保只运行一个实例
3. **配置文件安全**：`config.ahk` 已加入 `.gitignore`，不会被提交到版本控制系统
4. **重载脚本**：`Reload.bat` 会自动请求管理员权限，用于终止并重启脚本

## 系统要求

- Windows 操作系统
- AutoHotkey v2.0 或更高版本

## 许可证

MIT License
