#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; ==============================================================================
; AutoHotkey 脚本管理器 - 主入口文件
; ==============================================================================
; 功能说明：
; 这是主脚本文件，用于统一管理和加载所有子脚本
; 你只需要启动这一个文件，就可以加载所有需要的功能模块
; ==============================================================================

; 权限提升
if not A_IsAdmin
    Run '*RunAs "' A_ScriptFullPath '"'

; ==============================================================================
; 加载配置文件
; ==============================================================================
; 检查配置文件是否存在
configFile := A_ScriptDir "\config.ahk"
if !FileExist(configFile) {
    MsgBox "配置文件不存在！`n`n请复制 config.example.ahk 为 config.ahk 并配置你的参数。",
           "配置错误",
           "Icon! 16"
    ExitApp
}

; 加载配置文件
#Include config.ahk

; ==============================================================================
; 加载功能脚本
; ==============================================================================
; 在这里添加你需要启用的脚本模块
; 注释掉不需要的模块即可禁用该功能

; NumLock 相关功能
#Include scripts\FuckNumLock.ahk

; 可以在这里添加更多脚本，例如：
; #Include scripts\AnotherScript.ahk
; #Include scripts\YetAnotherScript.ahk

; ==============================================================================
; OSD 提示窗口函数（用于启动提示）
; ==============================================================================
ShowStartupOSD(message, duration := 2000) {
    ; 创建 GUI 窗口（无边框、置顶、工具窗口）
    startupGui := Gui("+AlwaysOnTop +ToolWindow -Caption +E0x20", "StartupOSD")
    startupGui.BackColor := "1a1a1a"  ; 深色背景
    startupGui.SetFont("s14 cWhite bold", "Microsoft YaHei UI")

    ; 窗口尺寸
    guiWidth := 200
    guiHeight := 60

    ; 添加文本控件，填满整个窗口并居中
    startupGui.AddText("x0 y0 w" guiWidth " h" guiHeight " Center 0x200", message)

    ; 设置窗口透明度
    WinSetTransparent(220, startupGui)

    ; 计算屏幕中央底部位置
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    xPos := (screenWidth - guiWidth) / 2
    yPos := screenHeight - 200  ; 距离底部 200 像素

    ; 显示窗口
    startupGui.Show("x" xPos " y" yPos " w" guiWidth " h" guiHeight " NA")

    ; 设置定时器自动关闭
    SetTimer () => startupGui.Destroy(), -duration
}

; ==============================================================================
; 脚本启动提示（可选）
; ==============================================================================
; 显示启动 OSD 提示（3 秒后自动消失）
ShowStartupOSD("AutoHotkey OK!", 3000)
