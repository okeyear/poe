; --------------------------------------------------------------------------------
; Copyleft by 版权没有
; e-mail :
; --------------------------------------------------------------------------------
; 使用说明：
; ~ : 自动一键喝药
; --------------------------------------------------------------------------------

; -------------------------------
; Make sure run as Admin
; -------------------------------
if not A_IsAdmin
    Run *RunAs "%A_ScriptFullPath%"

;~  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;~  Globals and Init
;~  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance Force
#IfWinActive, ahk_exe PathOfExile_x64.exe ;国服窗口信息
    SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
    SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

    ;Alt+T打开POE网页市集
    !T::
        Run https://poe.game.qq.com/trade
    return

    ; 绑定一键喝药
    `::
        {
            v_Enable:=!v_Enable
            if (v_Enable=0)
            {
                SetTimer, autoHP, Off
                SetTimer, Label2, Off
                SetTimer, Label3, Off
                SetTimer, Label4, Off
                SetTimer, autoMP, Off
                SetTimer, Labelq, Off
            }
            else
            {
                ; SetTimer, Label1, 7100
                SetTimer, autoHP, 800
                SetTimer, Label2, 13050
                SetTimer, Label3, 12000
                SetTimer, Label4, 9800
                SetTimer, autoMP, 2000
                ; SetTimer, Label5, 6400
                SetTimer, Labelq, 10050
            }
        }
    return

    Label1:
        {
            Random, delay1, 57, 114
            Sleep, %delay1%
            Send,1
        }
    return

    Label2:
        {
            Random, delay2, 57, 114
            Sleep, %delay2%
            Send,2
        }
    return

    Label3:
        {
            Random, delay3, 57, 114
            Sleep, %delay3%
            Send,3
        }
    return

    Label4:
        {
            Random, delay4, 57, 114
            Sleep, %delay4%
            Send,4
        }
    return

    Label5:
        {
            Random, delay5, 57, 114
            Sleep, %delay5%
            Send,5
        }
    return

    Labelw:
        {
            Random, delayw, 57, 114
            Sleep, %delayw%
            Send,w
        }
    return

    Labelq:
        {
            Random, delayq, 57, 114
            Sleep, %delayq%
            Send,q
        }
    return

    autoHP() {
        PixelGetColor, color, 109, 951 , RGB
        v := RGB2HSV(color)
        if (v < 0.4) {
            send 1
        }
    }

    autoMP() {
        PixelGetColor, color, 1806, 983 , RGB
        v := RGB2HSV(color)
        if (v < 0.4) {
            send 5
        }
    }

    RGB2HSV(color) {
        ; 提取rgb，转成10进制
        rgb := SubStr(color, 3, 6)
        r := toBase("0x"+SubStr(rgb, 1 , 2), 10)
        g := toBase("0x"+SubStr(rgb, 3 , 2), 10)
        b := toBase("0x"+SubStr(rgb, 5 , 2), 10)

        ; 转hsv
        cMax := max(r,g,b)
        cMin := min(r,g,b)
        dlta := cMax - cMin
        ; MsgBox %r%, %g%, %b%, %cMax%, %cMin%, %dlta%

        if (dlta != 0 && cMax == r) {
            h := (g - b) / dlta
        } else if (dlta != 0 && cMax == g) {
            h := (b - r) / dlta + 2
        } else if (dlta != 0 && cMax == b) {
            h := (r - g) / dlta + 4
        }
        h := h * 60
        if (h < 0) {
            h := h + 360
        }
        if (cMax != 0) {
            s := dlta / cMax
        }
        v := cMax / 255
        ; MsgBox %h%, %s%, %v%
        ; 这里得到三个值，我只返回了对我有用的v
        ; 如果需要在别处使用，请自行修改
    return v
}

toBase(n, b) {
    return (n < b ? "" : ToBase(n//b,b)) . ((d:=Mod(n,b)) < 10 ? d : Chr(d+55))
}

max(a, b, c) {
    return (a>=b && a>=c) ? a : (b>=a && b>=c) ? b : c
}

min(a, b, c) {
    return (a<=b && a<=c) ? a : (b<=a && b<=c) ? b : c
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

;