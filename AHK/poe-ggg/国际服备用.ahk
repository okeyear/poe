
;------------------------ 一键存包,长按开始,弹起按键 停止

; F9::
;     WinGetPos, x, y, w, h, A
;     bb_x := GetRandom(AdaptPosX(1300))
;     bb_y := GetRandom(AdaptPosY(615))
;     bb_w := 51 / 1080 * h
;     bb_h := 50 / 1080 * h
;     ; MsgBox %bb_x%,%bb_y%,%bb_w%,%bb_h%
;     Send, {ctrl down}
;     Random, delayautoclick, 57, 114
;     loop 12 {
;         loop 5 {
;             if GetKeyState("F9","P") { ; 如果按住的话
;                 MouseMove %bb_x%, %bb_y%
;                 Send, {Click}
;                 bb_y := bb_y + bb_h
;                 Sleep, delayautoclick
;             } else {
;                 Send, {ctrl up}
;                 break ; 不是按住退出循环
;             }
;         }
;         bb_y := bb_y - bb_h * 5
;         bb_x := bb_x + bb_w
;     }
;     Send, {ctrl up}
; return

; AdaptPosX(x_1920) {
;     WinGetPos, x, y, w, h, A
;     if (x_1920 > 1255) {
;         return w + (x_1920 - 1920) / 1080 * h
;     } else {
;         return x_1920 / 1080 * h
;     }
; }

; AdaptPosY(y_1080) {
;     WinGetPos, x, y, w, h, A
; return y_1080 / 1080 * h
; }

; GetRandom(num) {
;     Random, OutputVar , num - 5, num + 5
; return OutputVar
; }

;---------------
; -------------------------------
; 鼠标中键自动小退，一键切到角色选择界面
; MButton::
;     Send {enter}
;     SendInput {NumpadDiv}{Text}exit
;     Send {enter}
;     sleep 2000
;     Send {enter}
; Return

;一键邀请进队
; F9::
;     AutoDoCommandWithSomebody("/invite")
; return

; ;一键申请交易
; F6::
;    AutoDoCommandWithSomebody("/tradewith")
; return

; 一键回藏身处
;F12::
;    Send {Enter}
;    SendInput {NumpadDiv}{Text}hideout
;    Send {Enter}
;return

;-----------------------一、快捷操作-----------------------

; setMouseDelay, 10
; ; 一键连点
; 长按F6 : 一键执行ctrl+单击 , 不按弹起停止 , 比如鼠标悬停通货仓库回城卷轴上, 长按 就一直取, 不按就停止取
; F6::
;     Send, {ctrl down}
;     loop 5{
;         Random, delayclick, 57, 114
;         if GetKeyState("F6","P") { ; 如果按住的话
;             send, {Click}
;             Sleep, %delayclick%
;         } else {
;             Send, {ctrl up}
;             Break ; 不是按住退出循环
;         }
;     }
;     Send, {ctrl up}
; return

;--------------------------------------

;强制退出脚本
;F8::
;	ExitApp
;return

;F8暂停/恢复脚本
; F8::
;     Suspend
; return

;-----------------------二、一键回复-----------------------


;------------------------------------
; AutoDoCommandWithSomebody(command) { ;对上一次私聊你的人执行对应指令
;     BlockInput, On
;     Send ^{Enter}
;     Sleep 50
;     Send,{ShiftDown}{Home}{Right}{ShiftUp}
;     Sleep 50
;     _temp := Clipboard
;     Send,^C{ShiftDown}{Left}{ShiftUp}
;     ClipWait 2
;     _nickname := Clipboard
;     _Input = %command% %_nickname%
;     SendActualText(_Input)
;     Clipboard = %_temp%
;     Sleep 50
;     Send {Enter}
;     BlockInput, Off
; }

; AutoReply(text) { ;自动回复上一次私聊你的人
;     if (text) {
;         BlockInput, On
;         Send ^{Enter}
;         Sleep 50
;         SendActualText(text)
;         Sleep 50
;         Send {Enter}
;         BlockInput, Off
;     }
; }

SendActualText(text) { 
    ;粘贴指定文本，并且恢复剪贴板
    _temp := Clipboard
    Clipboard = %text%
    Send ^v
    Sleep 100
    Clipboard = %_temp%
}

;-------------------自动地雷-------------------------------------------------------
;---------------- Initialize Detonate Position -----------------------
    ; Ctrl + D : 初始化引爆按钮位置，需要放一个地雷技能，让右下角有图标，一次即可
    ; ctrl + Alt + D : 切换强制引爆，影响打字，但是在丹恩地图比较有用 , 这个和查价冲突, 暂时不开启
    ; D ：切换自动智能检测引爆，不影响打字

~^D::
    afterInit :=1
    IfWinExist, ahk_class POEWindowClass
    {
        WinGetPos, wLeft, wTop, wWidth, wHeight
        wRight := wLeft + wWidth
        wBottom := wTop + wHeight
        DetonateAbsX1 := wRight - Round(wWidth * 0.2)
        DetonateAbsY1 := wBottom - Round(wHeight * 0.2)
        DetonateAbsX2 := DetonateAbsX1 + Round(wWidth * 0.1)
        DetonateAbsY2 := DetonateAbsY1 + Round(wHeight * 0.1)
        PixelSearch ,Px , Py, %DetonateAbsX1%, %DetonateAbsY1%, %DetonateAbsX2%, %DetonateAbsY2%, %DetonateColor%, 1, Fast
        if ErrorLevel{
            ToolTip , Cannot find the Detonate Button
        } else {
            ToolTip , The Detonate Button is found X:%Px% Y:%Py%
            DetonateAbsX := Px
            DetonateAbsY := Py
        }
        SetTimer ,RemoveToolTip, -2000
        Detonating := 0
        Gui2X := DetonateAbsX - 20
        Gui2Y := DetonateAbsY + 16
        Gui 2:Show, x%Gui2X% y%Gui2Y%
        return
    } else {
        return
    }

~^!D::
    if (!afterInit) {
        return
    }

    if (ForceDetonating) {
        ForceDetonating := 0
        GuiControl, 2:, T1, Detonate: OFF
        Detonating := 0
        SetTimer, DetonateLoop, off
    } else {
        ForceDetonating := 1
        GuiControl, 2:, T1, DetonateForce
        Detonating := 1
        SetTimer, DetonateLoop, %Tick%
    }
return

~D::

    if (!afterInit) {
        return
    }

    if (ForceDetonating) {
        return
    }

    if (Detonating) {
        GuiControl, 2:, T1, Detonate: OFF
        Detonating := 0
        SetTimer, DetonateLoop, off
    } else {
        GuiControl, 2:, T1, Detonate: ON
        Detonating := 1
        SetTimer, DetonateLoop, %Tick%

    }
return

DetonateLoop:
    IfWinActive, ahk_class POEWindowClass
    {
        if (GetKeyState("Shift", "p")){
            return
        }else{
            PixelSearch, Px, Py, %DetonateAbsX%, %DetonateAbsY%, %DetonateAbsX%, %DetonateAbsY%, %DetonateColor%, 1, Fast
            if ErrorLevel and !ForceDetonating {
                return
            }
            else {
                Send {d}
            }
        }
    }
return

RemoveToolTip:
    ToolTip ,
return

;-----------------------三、一键打开网页-----------------------
;Alt+T打开POE网页市集
; !T::
;     ; Run https://www.pathofexile.com/trade
;     Run https://p.zifeng8.com/index.php/favorites/poe/
; return

