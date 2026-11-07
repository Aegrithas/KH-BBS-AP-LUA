LUAGUI_NAME = "bbsAPSeed"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "BBS FM AP Seed"

game_version = 1 --1: EGS GL v1.0.0.10, 2: Steam GL v1.0.0.2, 3: Steam JP v1.0.0.2
IsEpicGLVersion = 0x68D229
IsSteamGLVersion = 0x68D451
IsSteamJPVersion = 0x68C401
can_execute = false
frame_count = 0
patched = false

function version_choice(array, choice)
    a = array
    return a[choice]
end

world_ids = {
    ["The Land of Departure"]  = "1",
    ["Dwarf Woodlands"]        = "2",
    ["Castle of Dreams"]       = "3",
    ["Enchanted Dominion"]     = "4",
    ["The Mysterious Tower"]   = "5",
    ["Radiant Garden"]         = "6",
    ["Realm of Darkness"]      = "7",
    ["Olympus Coliseum"]       = "8",
    ["Deep Space"]             = "9",
    ["Never Land"]             = "B",
    ["Disney Town"]            = "C",
    ["The Keyblade Graveyard"] = "D",
}

if os.getenv('LOCALAPPDATA') ~= nil then
    client_communication_path = os.getenv('LOCALAPPDATA') .. "\\KHBBSFMAP\\"
else
    client_communication_path = os.getenv('HOME') .. "/KHBBSFMAP/"
    ok, err, code = os.rename(client_communication_path, client_communication_path)
    if not ok and code ~= 13 then
        os.execute("mkdir " .. path)
    end
end

items     = require "items"
iter      = require "iter"
locations = require "locations"

local function parse_is_local(local_str)
    if local_str == "local" then
        return true
    elseif local_str == "remote" then
        return false
    else
        error("expected 'local' or 'remote'; got '" .. tostring(local_str) .. "'")
    end
end

local function is_command(item)
    local command_categories = {
        ["Attack Command"]     = true,
        ["Magic Command"]      = true,
        ["Item Command"]       = true,
        ["Friendship Command"] = true,
        ["Movement Command"]   = true,
        ["Defense Command"]    = true,
        ["Reprisal Command"]   = true,
        ["Shotlock Command"]   = true,
    }
    return command_categories[item.category] ~= nil
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
    if can_execute then
    end
end

function _OnFrame()
    frame_count = (frame_count + 1) % 30
    if can_execute and frame_count == 0 then
        if ReadInt(version_choice({0x81911F, 0x81811F}, game_version)) ~= 0xFFFFFF00 then --Not on Title Screen
            if ReadInt(version_choice({0x81911F, 0x81811F}, game_version)) ~= 0xD0100 then
                if ReadInt(version_choice({0x81911F, 0x81811F}, game_version)) ~= 0x20100 or ReadInt(version_choice({0x819123, 0x818123}, game_version)) ~= 0x100 or ReadShort(version_choice({0x819127, 0x818127}, game_version)) ~= 0x100 then
                    local slot_character_file = io.open(client_communication_path .. "character.cfg", "r")
                    local slot_character = nil
                    if slot_character_file ~= nil then
                        slot_character = slot_character_file:read("*number")
                        slot_character_file:close()
                    end
                    local game_character = ReadByte(version_choice({0x10FA0F80, 0x10FA0880}, game_version))
                    if slot_character ~= nil and game_character == slot_character then
                        local field_item_address_pointer = GetPointer(version_choice({0x10FA0B40, 0x10FA0440}, game_version))
                        local location_patch = io.open(client_communication_path .. "location_patches.cfg", "r")
                        if field_item_address_pointer > 0 and not patched and location_patch ~= nil then
                            for line in location_patch:lines() do
                                local location_type, location_world, location_name, item_name, local_str = iter.unpack(line:gmatch("[^,]*"))
                                if local_str ~= nil then
                                    location = locations.locations_by_name[location_name]
                                    item = items.items_by_name[item_name]
                                    is_local = parse_is_local(local_str)
                                    
                                    if location == nil then
                                        error("unknown location '" .. location_name .. "'")
                                    end
                                    if is_local and item == nil then
                                        error("unknown item '" .. item_name .. "'")
                                    end
                                    if location.type ~= location_type then
                                        error("location type mismatch for location '" .. location.name .. "': received '" .. location_type .. "', knew '" .. location.type .. "'")
                                    end
                                    if location.world ~= location_world then
                                        error("location world mismatch for location '" .. location.name .. "': received '" .. location_world .. "', knew '" .. location.world .. "'")
                                    end
                                    
                                    local write_value = nil
                                    if location.type == "Sticker" then
                                        write_value = "1F1B"
                                        if is_local and item.category == "Keyblade" then
                                            write_value = item.khbbsid
                                        end
                                    elseif location.type == "Chest" then
                                        write_value = "001F1B"
                                        local item_prefix = nil
                                        if is_local and is_command(item) then
                                            item_prefix = "01"
                                        elseif is_local and item.category == "Keyblade" then
                                            item_prefix = "00"
                                        end
                                        if item_prefix ~= nil then
                                            write_value = item_prefix .. item.khbbsid
                                        end
                                    end
                                    if write_value ~= nil then
                                        write_value = locations.world_offsets[location.world] .. write_value
                                        WriteInt(field_item_address_pointer + location.offset, tonumber(write_value, 16), true)
                                    end
                                end
                            end
                            patched = true
                        end
                        if location_patch ~= nil then
                            location_patch:close()
                        end
                    end
                end
            end
        end
    end
end
