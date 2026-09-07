LUAGUI_NAME = "bbsAPRemoveItem"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "BBS FM AP Remove Item"

game_version = 1 --1: EGS GL v1.0.0.10, 2: Steam GL v1.0.0.2, 3: Steam JP v1.0.0.2
IsEpicGLVersion = 0x68D229
IsSteamGLVersion = 0x68D451
IsSteamJPVersion = 0x68C401
can_execute = false

function _OnInit()
    if ReadLong(IsEpicGLVersion) == 0x7265737563697065 then
        game_version = 1
        ConsolePrint("EGS GL v1.0.0.10 Detected")
        can_execute = true
    end
    if ReadLong(IsSteamGLVersion) == 0x7265737563697065 then
        game_version = 2
        ConsolePrint("Steam GL v1.0.0.2 Detected")
        can_execute = true
    end
    if ReadLong(IsSteamJPVersion) == 0x7265737563697065 then
        game_version = 3
        ConsolePrint("Steam JP v1.0.0.2 Detected")
        can_execute = true
    end
end

function _OnFrame()
    queue_address = {0x10FA41CA, 0x10FA3ACA}
    i = 0
    while i < 46 do
        if ReadShort(queue_address[game_version] + (i*2)) == 0x1F1B then
            WriteShort(queue_address[game_version] + (i*2), 0x0)
        end
        i = i + 1
    end
end
