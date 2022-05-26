#MaxThreadsPerHotkey 100
#SingleInstance Force
#NoEnv
#IfWinActive, ahk_exe PathOfExile_x64.exe

;====================== POE一键工具集国际服版 ======================
;功能整合：
;Ctrl+F4强制退出脚本 Ctrl+F11暂停/恢复脚本 Ctrl+F12唤起设置面板 
;
;一、快捷操作
;1.F2一键邀请进队
;2.F3一键申请交易
;3.F4一键回城
;4.F5一键小退
;二、一键回复功能
;Ctrl+F12唤起设置自动回复文字的面板
;可以自定义Ctrl+1 - Ctrl+5的自动回复文字
;三、一键打开网页
;1.Alt+G打开POE网页工具集，可以修改POE.html来更改工具集
;四、操作替代
;1.Ctrl+鼠标滚轮=方向键左右键(Win+W控制是否开启，鼠标会提示对应
;Switch on或者Switch off)
;2.~(1左边的键，参照国服)=一键喝药
;3.自动延误地雷，可自定义地雷按键，触发该按键时，片刻后会自动输
;入D引爆地雷
;
;====================== POE一键工具集国际服版 ======================

;-------------------------初始化---------------------------
Global LastSmokeMineKey

SetKeyDelay, 20
IniRead, IniCtrl1, settings.ini, poe_options, Ctrl1
IniRead, IniCtrl2, settings.ini, poe_options, Ctrl2
IniRead, IniCtrl3, settings.ini, poe_options, Ctrl3
IniRead, IniCtrl4, settings.ini, poe_options, Ctrl4
IniRead, IniCtrl5, settings.ini, poe_options, Ctrl5
IniRead, IniSmokeMine, settings.ini, poe_options, SmokeMineKey
BindHotkeys(IniSmokeMine)wD

;--------------------------UI面板-------------------------
Gui, 1:New,, 设置面板
Gui, 1:Add, Text, x10 h20, Ctrl+1
Gui, 1:Add, Edit, vReplyMsg1 w150 x+10 yp-3, % IniCtrl1
Gui, 1:Add, Text, x10 h20 y+10, Ctrl+2
Gui, 1:Add, Edit, vReplyMsg2 w150 x+10 yp-3, % IniCtrl2
Gui, 1:Add, Text, x10 h20 y+10, Ctrl+3
Gui, 1:Add, Edit, vReplyMsg3 w150 x+10 yp-3, % IniCtrl3
Gui, 1:Add, Text, x10 h20 y+10, Ctrl+4
Gui, 1:Add, Edit, vReplyMsg4 w150 x+10 yp-3, % IniCtrl4
Gui, 1:Add, Text, x10 h20 y+10, Ctrl+5
Gui, 1:Add, Edit, vReplyMsg5 w150 x+10 yp-3, % IniCtrl5

Gui, 1:Add, Text, x10 h20 y+10, 烟雾地雷按键：
Gui, 1:Add, Hotkey,vMineKey w100 x+10 yp-3 Limit190, % IniSmokeMine

Gui, 1:Add, Button, gSaveSettings w120 x50, 保存设置

Gui, 1:Show

return

SaveSettings:
Gui, 1:Submit, NoHide
IniWrite, % ReplyMsg1, settings.ini, poe_options, Ctrl1
IniWrite, % ReplyMsg2, settings.ini, poe_options, Ctrl2
IniWrite, % ReplyMsg3, settings.ini, poe_options, Ctrl3
IniWrite, % ReplyMsg4, settings.ini, poe_options, Ctrl4
IniWrite, % ReplyMsg5, settings.ini, poe_options, Ctrl5
IniWrite, % MineKey, settings.ini, poe_options, SmokeMineKey
IniCtrl1 := ReplyMsg1
IniCtrl2 := ReplyMsg2
IniCtrl3 := ReplyMsg3
IniCtrl4 := ReplyMsg4
IniCtrl5 := ReplyMsg5
IniSmokeMine := MineKey
Gui, 1:Hide
BindHotkeys(IniSmokeMine)
return

;绑定快捷键
BindHotkeys(IniSmokeMine){
	Hotkey, % "~" LastSmokeMineKey, AutoSmokeMine, Off
	if (IniSmokeMine) {
		Hotkey, % "~" IniSmokeMine, AutoSmokeMine, On
	}
	LastSmokeMineKey := IniSmokeMine
}

;自动烟雾地雷
AutoSmokeMine:
	Sleep 200
	Send D
return

;-----------------------一、快捷操作-----------------------
;F2一键邀请进队
F2::
	AutoDoCommandWithSomebody("/invite")
return

;F3一键申请交易
F3::
	AutoDoCommandWithSomebody("/tradewith")
return

;F4一键回城
F4::
	Send {Enter}
	Sleep 50
	Send,{ShiftDown}{Home}{ShiftUp}{BackSpace}
	Sleep 50
	SendActualText("/hideout")
	Sleep 50
	Send {Enter}
return

;F5一键小退
F5::
	Send {Enter}
	Sleep 50
	Send,{ShiftDown}{Home}{ShiftUp}{BackSpace}
	Sleep 50
	SendActualText("/Exit")
	Sleep 50
	Send {Enter}
return

;-----------------------二、一键回复-----------------------
;Ctrl+1
^1::
	AutoReply(IniCtrl1)
return

;Ctrl+2
^2::
	AutoReply(IniCtrl2)
return

;Ctrl+3
^3::
	AutoReply(IniCtrl3)
return

;Ctrl+4
^4::
	AutoReply(IniCtrl4)
return

;Ctrl+5
^5::
	AutoReply(IniCtrl5)
return

^F12::
	Gui, 1:Show
return
;-----------------------三、一键打开网页-----------------------
;Alt+G打开POE网页工具
!G::
	Run %A_WorkingDir%\POE.html
return

;-----------------------四、操作替代-----------------------
Global wheelswitchOff := 0
;鼠标滚轮
^WheelDown::
	if (wheelswitchOff) {
		Send {Right}
	}
return

^WheelUp::
	if (wheelswitchOff) {
		Send {Left}
	}
return

#W::
	if (!wheelswitchOff) {
		wheelswitchOff := 1
		ToolTip, switch on
	} else {
		wheelswitchOff := 0
		ToolTip, switch off
	}
	SetTimer, RemoveToolTip, -2000
return

RemoveTooltip:
	ToolTip
return

;一键喝药
`::
	Send {1}{2}{3}{4}{5}
return

;Ctrl+F11暂停/恢复脚本
^F11::
	Suspend
return

;Ctrl+F4强制退出脚本
^F4::
	ExitApp
return

AutoDoCommandWithSomebody(command) { ;对上一次私聊你的人执行对应指令
	BlockInput, On
	Send ^{Enter}
	Sleep 50
	Send,{ShiftDown}{Home}{Right}{ShiftUp}
	Sleep 50
	_temp := Clipboard
	Send,^C{ShiftDown}{Left}{ShiftUp}
	ClipWait 2
	_nickname := Clipboard
	_Input = %command% %_nickname%
	SendActualText(_Input)
	Clipboard = %_temp%
	Sleep 50
	Send {Enter}
	BlockInput, Off
}

AutoReply(text) { ;自动回复上一次私聊你的人
	if (text) {
		BlockInput, On
		Send ^{Enter}
		Sleep 50
		SendActualText(text)
		Sleep 50
		Send {Enter}
		BlockInput, Off
	}
}

SendActualText(text) { ;粘贴指定文本，并且恢复剪贴板
	_temp := Clipboard
	Clipboard = %text%
	Send ^v
	Sleep 100
	Clipboard = %_temp%
}
