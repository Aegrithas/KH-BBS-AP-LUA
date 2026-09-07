LUAGUI_NAME = "bbsAPEXPMultiplier"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "BBS FM AP EXP Multiplier"

game_version = 1 --1: EGS GL v1.0.0.10, 2: Steam GL v1.0.0.2, 3: Steam JP v1.0.0.2
IsEpicGLVersion = 0x68D229
IsSteamGLVersion = 0x68D451
IsSteamJPVersion = 0x68C401
can_execute = false

exp_mult = 1
mult_applied = false
mult_read = false
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

function read_mult()
    if not mult_read then
        if file_exists(client_communication_path .. "xpmult.cfg") then
            file = io.open(client_communication_path .. "xpmult.cfg", "r")
            io.input(file)
            exp_mult = tonumber(io.read())
            io.close(file)
            mult_read = true
        elseif file_exists(client_communication_path .. "EXP Multiplier.cfg") then
            file = io.open(client_communication_path .. "EXP Multiplier.cfg", "r")
            io.input(file)
            exp_mult = tonumber(io.read())
            io.close(file)
            mult_read = true
        else
            exp_mult = 1
        end
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
    frame_count = (frame_count + 1) % 30
    if can_execute and frame_count == 0 then
        read_mult()
        to_next_level_table_address = {0x649734, 0x649604}
        if exp_mult ~= 1 and ReadInt(to_next_level_table_address[game_version]) == 90 then
            for i=1,99 do
                to_next_level_address = to_next_level_table_address[game_version] + ((i-1)*4)
                WriteInt(to_next_level_address, math.ceil(ReadInt(to_next_level_address)/exp_mult))
            end
        end
    end
end
