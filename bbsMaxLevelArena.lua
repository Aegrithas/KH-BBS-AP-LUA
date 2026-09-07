LUAGUI_NAME = "Max Arena Level"
LUAGUI_AUTH = "KSX"
LUAGUI_DESC = "Max Arena Level"

IsEpicGLVersion = 0x68D229
IsSteamGLVersion = 0x68D451
IsSteamJPVersion = 0x68C401


-------------------------------------------------------------------------
function _OnInit()
	if ENGINE_TYPE == "BACKEND" then
	epicgames = 0
	stmgames = 0
	stmjpgames = 0
	end
end
-------------------------------------------------------------------------
function _OnFrame()

	if ReadLong(IsEpicGLVersion) == 0x7265737563697065 and epicgames == 0 then
		epicgames = 1
		ConsolePrint("Max Arena Level (EPIC GL) - installed")
	end
	
	if ReadLong(IsSteamGLVersion) == 0x7265737563697065 and stmgames == 0 then
		stmgames = 1
		ConsolePrint("Max Arena Level (Steam GL) - installed")
	end
	
	if ReadLong(IsSteamJPVersion) == 0x7265737563697065 and stmjpgames == 0 then
		stmjpgames = 1
		ConsolePrint("Max Arena Level (Steam JP) - installed")
	end

---------- Epic Games Version
if epicgames == 1 then
WriteByte(0x10F9F5E7, 30)
WriteByte(0x10FA695C, 30)
end

---------- Steam Version
if stmgames == 1 then
WriteByte(0x10F9EEE7, 30)
WriteByte(0x10FA625C, 30)
end

---------- Steam JP Version
if stmjpgames == 1 then
WriteByte(0x10F9EEE7-0x1000, 30)
WriteByte(0x10FA625C-0x1000, 30)
end

end
