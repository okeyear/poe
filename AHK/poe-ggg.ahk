; -------------------------------
; Make sure run as Admin
; 确保以管理员身份运行脚本
; -------------------------------
if not A_IsAdmin
    Run *RunAs "%A_ScriptFullPath%"

; -------------------------------
;~  Globals and Init
; -------------------------------
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
#MaxThreadsPerHotkey 100
#SingleInstance Force
; 在当前活动窗口生效,其他窗口不生效
#IfWinActive, ahk_exe PathOfExile.exe
    SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
    SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
    ; --------------------------------------------------------------------------------
    ; 使用说明：
    ; ~ : 自动一键喝药,需要自己修改左下角血圆球的喝药位置, 和右下角蓝圆球,喝药的位置

    ; 长按F9 : 一键存背包物品 , 不按弹起停止
	; F12 一键回藏身处 
    ; --------------------------------------------------------------------------------

    ; 绑定一键喝药
    
;~RButton::
;~space::
;	sleep 300
;	Send q
;	sleep 300
;	Send t
;return

    `::
        {
            v_Enable:=!v_Enable
            if (v_Enable=0)
            {
                SetTimer, autoHP, Off
                SetTimer, Label2, Off
                ;SetTimer, Label3, Off
                SetTimer, Label4, Off
                ;SetTimer, autoMP, Off
                SetTimer, Label5, Off
                ;SetTimer, Labelw, Off
                ;SetTimer, Labelq, Off
            }
            else
            {
                ; SetTimer, Label1, 7100
                SetTimer, autoHP, 800
                SetTimer, Label2, 9650
                ;SetTimer, Label3, 6150
                SetTimer, Label4, 6050
                ;SetTimer, autoMP, 800
                SetTimer, Label5, 7250
                ;SetTimer, Labelw, 3950
                ;SetTimer, Labelq, 5050
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
        PixelGetColor, color, 104, 885 , RGB
        v := RGB2HSV(color)
        if (v < 0.4) {
            Send 1
        }
    }

    autoMP() {
        PixelGetColor, color, 1806, 983 , RGB
        v := RGB2HSV(color)
        if (v < 0.4) {
            Send 5
        }
    }

    ; F2::
    ;     PixelGetColor, color, 406, 967 , RGB
    ;     v := RGB2HSV(color)
    ;     MsgBox %v%
    ; return

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
    return (n < b ? "" : toBase(n//b,b)) . ((d:=Mod(n,b)) < 10 ? d : Chr(d+55))
}

max(a, b, c) {
    return (a>=b && a>=c) ? a : (b>=a && b>=c) ? b : c
}

min(a, b, c) {
    return (a<=b && a<=c) ? a : (b<=a && b<=c) ? b : c
}

;------------------------ 一键存包,长按开始,弹起按键 停止



^1::
	;     商店快速找三連串 召唤，带烟雾地雷所以有绿孔
	SendActualText("b-b-r|b-r-b|r-b-b|g-b-b|b-b-g|b-g-b|b-b-b|runner")
return

^2::
	;     商店快速找三連串 （远程，弓）
	SendActualText("g-g-g|g-g-b|g-b-g|b-g-g|g-g-r|g-r-g|r-g-g|runner")
return

;
^3::
    ; 	黄金港夺宝 搜索
	SendActualText("Lock|Demo|Perc|Decep")
return





; Caster（法术）
; b-b-g|b-g-b|g-b-b|g-g-b|g-b-g|b-g-g|b-b-b|runner

; Melee（近战）
; r-r-r|r-r-g|r-g-r|g-r-r|g-g-r|g-r-g|r-g-g|runner

; Ranged（远程，弓）
; g-g-g|g-g-b|g-b-g|b-g-g|g-g-r|g-r-g|r-g-g|runner

; Minion（召唤，带烟雾地雷所以有绿孔）
; b-b-r|b-r-b|r-b-b|g-b-b|b-b-g|b-g-b|b-b-b|runner
SendActualText(text) { 
    ;粘贴指定文本，并且恢复剪贴板
    _temp := Clipboard
    Clipboard = %text%
    Send ^v
    Sleep 100
    Clipboard = %_temp%
}

