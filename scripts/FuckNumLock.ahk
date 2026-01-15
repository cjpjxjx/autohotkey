#Requires AutoHotkey v2.0

; ==============================================================================
; NumLock 功能脚本
; ==============================================================================
; 功能说明：
; 1. 强制 NumLock 常亮
; 2. 双击 NumLock 键映射为快速输入预设文本
; 3. 小键盘数字键映射（无论 NumLock 状态如何都输出数字）
; ==============================================================================

; 强制 NumLock 常亮
SetNumLockState "AlwaysOn"

; ==============================================================================
; OSD 提示窗口函数
; ==============================================================================
ShowOSD(message, duration := 1000) {
    ; 如果 OSD 窗口已存在，先销毁
    try {
        if IsSet(osdGui)
            osdGui.Destroy()
    }

    ; 创建 GUI 窗口（无边框、置顶、工具窗口）
    static osdGui := ""
    osdGui := Gui("+AlwaysOnTop +ToolWindow -Caption +E0x20", "OSD")
    osdGui.BackColor := "1a1a1a"  ; 深色背景
    osdGui.SetFont("s14 cWhite bold", "Microsoft YaHei UI")

    ; 窗口尺寸
    guiWidth := 150
    guiHeight := 50

    ; 添加文本控件，填满整个窗口并居中
    osdGui.AddText("x0 y0 w" guiWidth " h" guiHeight " Center 0x200", message)

    ; 设置窗口透明度
    WinSetTransparent(220, osdGui)

    ; 计算屏幕中央底部位置
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    xPos := (screenWidth - guiWidth) / 2
    yPos := screenHeight - 200  ; 距离底部 200 像素

    ; 显示窗口
    osdGui.Show("x" xPos " y" yPos " w" guiWidth " h" guiHeight " NA")

    ; 设置定时器自动关闭
    SetTimer () => osdGui.Destroy(), -duration
}

; ==============================================================================
; IME (输入法) 辅助函数
; ==============================================================================
; 获取输入法状态：返回 1=开启(中文), 0=关闭(英文)
IME_GET(hWnd) {
    return DllCall("User32.dll\SendMessage", "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hWnd, "Ptr"), "UInt", 0x0283, "Int", 0x0005, "Int", 0, "Int")
}

; 设置输入法状态：state 为 1=开启(中文), 0=关闭(英文)
IME_SET(state, hWnd) {
    return DllCall("User32.dll\SendMessage", "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hWnd, "Ptr"), "UInt", 0x0283, "Int", 0x0006, "Int", state, "Int")
}

; ==============================================================================
; 功能 1：双击 NumLock 键 -> 慢速稳定输入文本
; ==============================================================================
; 检测双击：两次按键间隔小于 300 毫秒视为双击
NumLock::
{
    ; 检测是否为双击
    if (A_PriorHotkey = "NumLock" && A_TimeSincePriorHotkey < 300)
    {
        ; 保存当前输入法状态
        currentWindow := WinExist("A")
        originalIMEStatus := IME_GET(currentWindow)

        ; 如果输入法开启（中文状态），则关闭它（切换到英文）
        if (originalIMEStatus = 1) {
            IME_SET(0, currentWindow)
            Sleep 25  ; 等待输入法切换完成
        }

        ; 设置按键延迟：按下时长 25ms，按键间隔 25ms
        SetKeyDelay 25, 25

        ; 使用 Raw 模式逐字符发送，更适合虚拟化环境
        ; Raw 模式直接发送字符码，不进行任何转换
        Loop Parse, NumLockInput
        {
            SendEvent "{Raw}" A_LoopField
        }

        ; 恢复原输入法状态
        if (originalIMEStatus = 1) {
            Sleep 25  ; 等待输入完成后再切换输入法
            IME_SET(1, currentWindow)
        }

        ; 根据配置决定是否显示 OSD 提示
        if (ShowOSDNotification)
            ShowOSD("输入完成", 1000)
    }
    ; 单击时不做任何操作（NumLock 已设置为常亮）
}

; ==============================================================================
; 功能 2：小键盘数字键映射
; ==============================================================================
; 下面这些键依然保持瞬发，因为单键映射不需要延迟，也不存在乱码问题

*Numpad0::Send "{Blind}0"
*NumpadIns::Send "{Blind}0"

*Numpad1::Send "{Blind}1"
*NumpadEnd::Send "{Blind}1"

*Numpad2::Send "{Blind}2"
*NumpadDown::Send "{Blind}2"

*Numpad3::Send "{Blind}3"
*NumpadPgDn::Send "{Blind}3"

*Numpad4::Send "{Blind}4"
*NumpadLeft::Send "{Blind}4"

*Numpad5::Send "{Blind}5"
*NumpadClear::Send "{Blind}5"

*Numpad6::Send "{Blind}6"
*NumpadRight::Send "{Blind}6"

*Numpad7::Send "{Blind}7"
*NumpadHome::Send "{Blind}7"

*Numpad8::Send "{Blind}8"
*NumpadUp::Send "{Blind}8"

*Numpad9::Send "{Blind}9"
*NumpadPgUp::Send "{Blind}9"

*NumpadDot::Send "{Blind}."
*NumpadDel::Send "{Blind}."
