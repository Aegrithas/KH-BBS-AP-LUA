LUAGUI_NAME = "bbsAPKeybladeStats"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "Kingdom Hearts BBS AP Integration"

game_version = 1 --1: EGS GL v1.0.0.10, 2: Steam GL v1.0.0.2, 3: Steam JP v1.0.0.2

local keyblade_stats_base_address = {0x81AAEC, 0x819AEC}

IsEpicGLVersion = 0x68D229
IsSteamGLVersion = 0x68D451
IsSteamJPVersion = 0x68C401
can_execute = false
frame_count = 0

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KHBBSFMAP\\"
else
    client_communication_path = os.getenv('HOME') .. "/KHBBSFMAP/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function read_keyblade_stats()
    if file_exists(client_communication_path .. "keyblade_stats.cfg") then
        file = io.open(client_communication_path .. "keyblade_stats.cfg", "r")
        io.input(file)
        keyblade_stats = split(io.read(),",")
        io.close(file)
        return keyblade_stats
    elseif file_exists(client_communication_path .. "Keyblade Stats.cfg") then
        file = io.open(client_communication_path .. "Keyblade Stats.cfg", "r")
        io.input(file)
        keyblade_stats = split(io.read(),",")
        io.close(file)
        return keyblade_stats
    else
        return nil
    end
end

function write_keyblade_stats(keyblade_stats)
    i = 1
    j = 0
    while i <= #keyblade_stats do
        str = tonumber(keyblade_stats[i])
        mgc  = tonumber(keyblade_stats[i+1])
        WriteByte(keyblade_stats_base_address[game_version] + (12 * j), str)
        WriteByte(keyblade_stats_base_address[game_version] + (12 * j) + 1, mgc)
        i = i + 2
        j = j + 1
    end
end

function main()
    keyblade_stats = read_keyblade_stats()
    if keyblade_stats ~= nil and not finished then
        write_keyblade_stats(keyblade_stats)
        finished = true
    end
end

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
    if frame_count == 0 and can_execute then
        main()
    end
    frame_count = (frame_count + 1) % 30
end
