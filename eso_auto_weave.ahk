;=============================================
; name:    eso_auto_weaver
; version: 1.3
;=============================================

#SingleInstance, force
#NoEnv

#UseHook
#InstallMouseHook
#InstallKeybdHook

SendMode Input
SetWorkingDir %A_ScriptDir%

;=============================================
; configuration
;=============================================

; input delays and timers
global la_delay := 185
global cn_delay := 500
global bl_delay := 50

; global cooldown ticker
global cd_timer := 900
global cd_delay := cd_timer - (la_delay + cn_delay + bl_delay)

; skill keys configured in array for [skill], [shouldWeave] & [shouldCancel]
global SkillKeys := [{skill: "1", weave: 1, cancel: 0}, {skill: "2", weave: 1, cancel: 1}, {skill: "3", weave: 1, cancel: 1}, {skill: "4", weave: 1, cancel: 0}, {skill: "5", weave: 0, cancel: 0}]

;=============================================
; primary script & input loop
;=============================================

; only capture keys when game window is running
#ifWinActive Elder Scrolls Online

Hotkey, 1, Weave_1, On
Hotkey, 2, Weave_2, On
Hotkey, 3, Weave_3, On
Hotkey, 4, Weave_4, On
Hotkey, 5, Weave_5, On

loop,
{
	; Input, in_key, L1 V ; no longer used [retained for future]
	; disable autoweaving in menus
	if(GetKeyState("I") || GetKeyState("M") || GetKeyState("J") || GetKeyState("O") || GetKeyState("Esc")) {
		SetCapsLockState , off		
	} 
	
}

Return

Weave_1:
    AutoWeave(SkillKeys[1].skill, SkillKeys[1].weave, SkillKeys[1].cancel)
Return

Weave_2:
    AutoWeave(SkillKeys[2].skill, SkillKeys[2].weave, SkillKeys[2].cancel)
Return

Weave_3:
    AutoWeave(SkillKeys[3].skill, SkillKeys[3].weave, SkillKeys[3].cancel)
Return

Weave_4:
    AutoWeave(SkillKeys[4].skill, SkillKeys[4].weave, SkillKeys[4].cancel)
Return

Weave_5:
    AutoWeave(SkillKeys[5].skill, SkillKeys[5].weave, SkillKeys[5].cancel)
Return

;=============================================
; helpers
;=============================================

; optional parameter [isBarswap] used for attack chaining (combo/rotation)
AutoWeave(skill, shouldWeave, shouldCancel, isBarswap:=false)
{
	if(GetKeyState("Capslock", "T")){
		remainder = 0

		; randomly generated variance prevents message stacking
		Random, variance, 1, 100

		if (shouldWeave) {
			Send, {Click}
			Sleep la_delay
			
		} else {
			remainder += la_delay		
		}
		
		Send, {%skill%}	
		Sleep cn_delay + variance
		
		if (shouldCancel) {
			if(isBarswap) { 
				Send, {``}
				Sleep bl_delay
				
			} else { 
				Send, {Click, down, right} 
				Sleep bl_delay
				Send, {Click, up, right}			
			}

		} else {
			remainder += bl_delay		
		}
		
		; observe the gcd
		Sleep (cd_delay + remainder) - variance
		
	} else {
		Send, {%skill%}	
		Sleep cd_timer	
	}
}

;=============================================
; EoF
;=============================================
