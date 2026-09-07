LUAGUI_NAME = "bbsAPHandleDeathlink"
LUAGUI_AUTH = "Gicu and Meebo"
LUAGUI_DESC = "BBS FM AP Handle Deathlink"

game_version = 1 --1: EGS GL v1.0.0.10, 2: Steam GL v1.0.0.2, 3: Steam JP v1.0.0.2
IsEpicGLVersion = 0x68D229
IsSteamGLVersion = 0x68D451
IsSteamJPVersion = 0x68C401
can_execute = false

last_death_time = 0
last_hp = 100

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

function version_choice(array, choice)
    a = array
    return a[choice]
end

function kill_player()
    death_pointer_address = {0x10F9F540, 0x10F9EE40}
    death_pointer_offset = 0x154
    if ReadInt(death_pointer_address[game_version]) ~= 0 then
        death_pointer = GetPointer(death_pointer_address[game_version], death_pointer_offset)
        if ReadInt(death_pointer, true) < 3 and ReadInt(death_pointer, true) > 0 then
            WriteInt(death_pointer, 3, true)
        end
    end
end

function character_selected_or_save_loaded()
    if can_execute then
        if ReadInt(version_choice({0x81911F, 0x81811F}, game_version)) ~= 0xFFFFFF00 then --Not on Title Screen
            if ReadInt(version_choice({0x81911F, 0x81811F}, game_version)) ~= 0xD0100 then
                if ReadInt(version_choice({0x81911F, 0x81811F}, game_version)) ~= 0x20100 or ReadInt(version_choice({0x819123, 0x818123}, game_version)) ~= 0x100 or ReadShort(version_choice({0x819127, 0x818127}, game_version)) ~= 0x100 then
                    return true
                end
            end
        end
    end
end

function get_current_hp()
    hp_pointer_address = {0x10F9F540, 0x10F9EE40}
    if ReadInt(hp_pointer_address[game_version]) > 0 then
        hp_pointer_offset_1 = 0x118
        hp_pointer_offset_2 = 0x398
        hp_pointer_offset_3 = 0xA0
        hp_pointer = GetPointer(hp_pointer_address[game_version], hp_pointer_offset_1)
        hp_pointer = GetPointer(hp_pointer, hp_pointer_offset_2, true)
        hp_pointer = GetPointer(hp_pointer, hp_pointer_offset_3, true)
        return ReadShort(hp_pointer, true)
    else
        return -1
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
    if file_exists(client_communication_path .. "dlreceive") then
        file = io.open(client_communication_path .. "dlreceive")
        io.input(file)
        death_time = tonumber(io.read())
        if death_time ~= nil then
            last_death_time = death_time
        end
        io.close(file)
    end
end

function _OnFrame()
    if can_execute then
        if character_selected_or_save_loaded() then
            if file_exists(client_communication_path .. "dlreceive") then
                file = io.open(client_communication_path .. "dlreceive")
                io.input(file)
                death_time = tonumber(io.read())
                io.close(file)
                if death_time ~= nil and last_death_time ~= nil then
                    if death_time >= last_death_time + 3 then
                        kill_player()
                        last_death_time = death_time
                    end
                end
            end
            current_hp = get_current_hp()
            if current_hp == 0 and last_hp > 0 then
                ConsolePrint("Sending death")
                ConsolePrint("Player's HP: " .. tostring(current_hp))
                ConsolePrint("Player's Last HP: " .. tostring(last_hp))
                death_date = os.date("!%Y%m%d%H%M%S")
                if not file_exists(client_communication_path .. "dlsend" .. tostring(death_date)) then
                    file = io.open(client_communication_path .. "dlsend" .. tostring(death_date), "w")
                    io.output(file)
                    io.write("")
                    io.close(file)
                end
            end
            last_hp = get_current_hp()
        end
    end
end
