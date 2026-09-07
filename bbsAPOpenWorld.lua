LUAGUI_NAME = "bbsAPOpenWorld"
LUAGUI_AUTH = "Sonicshadowsilver2"
LUAGUI_DESC = "BBS FM AP Open World"

game_version = 1 --1: EGS GL v1.0.0.10, 2: Steam GL v1.0.0.2, 3: Steam JP v1.0.0.2
IsEpicGLVersion = 0x68D229
IsSteamGLVersion = 0x68D451
IsSteamJPVersion = 0x68C401
can_execute = false

worlds_unlocked_array = {1,0,0,0,0,0,0,0,0,0,0,0,0}

function toBits(num, zeroes)
    -- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while num>0 do
        rest=math.fmod(num,2)
        t[#t+1]=rest
        num=(num-rest)/2
    end
    for i=1,8 do
        if t[i] == nil then
            t[i] = 0
        end
    end
    for i=1,zeroes do
        if t[i] == nil then
            t[i] = 0
        end
    end
    return t
end

function toNum(bits)
    --returns a number previously represented by bits
    num = 0
    for i=1,#bits do
        if bits[i] == 1 then
            num = num + (2^(i-1))
        end
    end
    return num
end


function read_world_item()
    ap_bits_address = {0x10FA349C, 0x10FA2D9C}
    world_item_byte_array = ReadArray(ap_bits_address[game_version], 2)
    world_item_bits_1 = toBits(world_item_byte_array[1], 8)
    world_item_bits_2 = toBits(world_item_byte_array[2], 8)
    worlds_unlocked_array[1] = 1 --LOD always unlocked
    worlds_unlocked_array[2] = world_item_bits_1[2]
    worlds_unlocked_array[3] = world_item_bits_1[3]
    worlds_unlocked_array[4] = world_item_bits_1[4]
    worlds_unlocked_array[5] = world_item_bits_1[5]
    worlds_unlocked_array[6] = world_item_bits_1[6]
    worlds_unlocked_array[7] = world_item_bits_1[7]
    worlds_unlocked_array[8] = world_item_bits_1[8]
    worlds_unlocked_array[9] = world_item_bits_2[1]
    worlds_unlocked_array[10] = world_item_bits_2[2]
    worlds_unlocked_array[11] = world_item_bits_2[3]
    worlds_unlocked_array[12] = world_item_bits_2[4]
    worlds_unlocked_array[13] = world_item_bits_2[5]
end

function read_number_of_wayfinders()
    key_item_stock_address = {0x10FA422C, 0x10FA3B2C}
    max_items = 40
    item_index = 0
    wayfinders = {}
    wayfinders[0x1F1C] = 0
    wayfinders[0x1F1F] = 0
    wayfinders[0x1F20] = 0
    while ReadShort(key_item_stock_address[game_version] - (2 * item_index)) ~= 0 and item_index < max_items do
        item_value = ReadShort(key_item_stock_address[game_version] - (2 * item_index))
        if item_value == 0x1F1C or item_value == 0x1F1F or item_value == 0x1F20 then
            wayfinders[item_value] = 1
        end
        item_index = item_index + 1
    end
    return wayfinders[0x1F1C] + wayfinders[0x1F1F] + wayfinders[0x1F20]
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

function _OnInit()
    Now = {0x819120, 0x818120}
    Save = {0x10FA0F70, 0x10FA0870}
    RoomNameText = {0xCB8652, 0xCB7F52}
    CharMod = {0x10F9F54C, 0x10F9EE4C}
    BGM = {0x87086C, 0x87016C}
    Book = {0x81C6F0, 0x81B6F0}
    Timer = {0x81EF20, 0x81DF24}
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

function BitOr(Address,Bit,Abs)
    WriteByte(Address,ReadByte(Address)|Bit,Abs and OnPC)
end
        
function BitNot(Address,Bit,Abs)
    WriteByte(Address,ReadByte(Address)&~Bit,Abs and OnPC)
end

function _OnFrame()
    if can_execute then
        --Unlock Tutorial Skip Option
        if ReadByte(Save[game_version]+0x11E89) << 7 then
            WriteByte(Save[game_version]+0x11E89,7)
        end
        --Battle/Combat Level 1 (New Game)
        if ReadByte(Save[game_version]+0x2815) == 0x01 and ReadByte(Save[game_version]+0x2821) == 0x00 then
            WriteByte(Save[game_version]+0x2810,0x01)
        end
        --Set Battle/Combat Levels
        if ReadShort(Save[game_version]+0x2810) == 0x01 then -- Combat Lv 1
            WriteArray(Save[game_version]+0x2815,{0x01, 0x01, 0x01, 0x01, 0x01}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x01)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x01)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x01, 0x01, 0x01, 0x01, 0x01, 0x01}) --Special, OC, DS, DI, NL, & DT
            if ReadByte(Save[game_version]+0x10) == 0x00 then --Ventus's The Keyblade Graveyard
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --Vanitas I Defeated
                    WriteByte(Save[game_version]+0x2821,0x09)
                else
                    WriteByte(Save[game_version]+0x2821,0x01)
                end
            end
        elseif ReadShort(Save[game_version]+0x2810) == 0x02 then -- Combat Lv 2
            WriteArray(Save[game_version]+0x2815,{0x02, 0x02, 0x02, 0x02, 0x02}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x02)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x02)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x02, 0x02, 0x02, 0x02, 0x02, 0x02}) --Special, OC, DS, DI, NL, & DT
            if ReadByte(Save[game_version]+0x10) == 0x00 then --Ventus's The Keyblade Graveyard
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --Vanitas I Defeated
                    WriteByte(Save[game_version]+0x2821,0x09)
                else
                    WriteByte(Save[game_version]+0x2821,0x02)
                end
            end
        elseif ReadShort(Save[game_version]+0x2810) == 0x03 then --Combat Lv 3
            WriteArray(Save[game_version]+0x2815,{0x03, 0x03, 0x03, 0x03, 0x03}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x03)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x03)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x03, 0x03, 0x03, 0x03, 0x03, 0x03}) --Special, OC, DS, DI, NL, & DT
            if ReadByte(Save[game_version]+0x10) == 0x00 then --Ventus's The Keyblade Graveyard
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --Vanitas I Defeated
                    WriteByte(Save[game_version]+0x2821,0x09)
                else
                    WriteByte(Save[game_version]+0x2821,0x03)
                end
            end
        elseif ReadShort(Save[game_version]+0x2810) == 0x04 then --Combat Lv 4
            WriteArray(Save[game_version]+0x2815,{0x04, 0x04, 0x04, 0x04, 0x04}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x04)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x04)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x04, 0x04, 0x04, 0x04, 0x04, 0x04}) --Special, OC, DS, DI, NL, & DT
            if ReadByte(Save[game_version]+0x10) == 0x00 then --Ventus's The Keyblade Graveyard
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --Vanitas I Defeated
                    WriteByte(Save[game_version]+0x2821,0x09)
                else
                    WriteByte(Save[game_version]+0x2821,0x04)
                end
            end
        elseif ReadShort(Save[game_version]+0x2810) == 0x05 then --Combat Lv 5
            WriteArray(Save[game_version]+0x2815,{0x05, 0x05, 0x05, 0x05, 0x05}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x05)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x05)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x05, 0x05, 0x05, 0x05, 0x05, 0x05}) --Special, OC, DS, DI, NL, & DT
            if ReadByte(Save[game_version]+0x10) == 0x00 then --Ventus's The Keyblade Graveyard
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --Vanitas I Defeated
                    WriteByte(Save[game_version]+0x2821,0x09)
                else
                    WriteByte(Save[game_version]+0x2821,0x05)
                end
            end
        elseif ReadShort(Save[game_version]+0x2810) == 0x06 then --Combat Lv 6
            WriteArray(Save[game_version]+0x2815,{0x06, 0x06, 0x06, 0x06, 0x06}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x06)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x06)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x06, 0x06, 0x06, 0x06, 0x06, 0x06}) --Special, OC, DS, DI, NL, & DT
            if ReadByte(Save[game_version]+0x10) == 0x00 then --Ventus's The Keyblade Graveyard
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --Vanitas I Defeated
                    WriteByte(Save[game_version]+0x2821,0x09)
                else
                    WriteByte(Save[game_version]+0x2821,0x06)
                end
            end
        elseif ReadShort(Save[game_version]+0x2810) == 0x07 then --Combat Lv 7
            WriteArray(Save[game_version]+0x2815,{0x07, 0x07, 0x07, 0x07, 0x07}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x07)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x07)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x07, 0x07, 0x07, 0x07, 0x07, 0x07}) --Special, OC, DS, DI, NL, & DT
            if ReadByte(Save[game_version]+0x10) == 0x00 then --Ventus's The Keyblade Graveyard
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --Vanitas I Defeated
                    WriteByte(Save[game_version]+0x2821,0x09)
                else
                    WriteByte(Save[game_version]+0x2821,0x07)
                end
            end
        elseif ReadShort(Save[game_version]+0x2810) == 0x08 then --Combat Lv 8
            WriteArray(Save[game_version]+0x2815,{0x08, 0x08, 0x08, 0x08, 0x08}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x08)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x08)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x08, 0x08, 0x08, 0x08, 0x08, 0x08}) --Special, OC, DS, DI, NL, & DT
            if ReadByte(Save[game_version]+0x10) == 0x00 then --Ventus's The Keyblade Graveyard
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --Vanitas I Defeated
                    WriteByte(Save[game_version]+0x2821,0x09)
                else
                    WriteByte(Save[game_version]+0x2821,0x08)
                end
            end
        elseif ReadShort(Save[game_version]+0x2810) == 0x09 then --Combat Lv 9
            WriteArray(Save[game_version]+0x2815,{0x09, 0x09, 0x09, 0x09, 0x09}) --TLoD, DW, CoD, ED, & TMT
            if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 then --RG
                WriteByte(Save[game_version]+0x281A,0x09)
            end
            if ReadByte(Save[game_version]+0x10) == 0x01 then --Aqua's Radiant Garden
                if ReadByte(Save[game_version]+0x26BC) == 0x01 then --In Final Episode
                    WriteByte(Save[game_version]+0x281A,0x0A)
                else
                    WriteByte(Save[game_version]+0x281A,0x09)
                end
            end
            WriteArray(Save[game_version]+0x281B,{0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09}) --Special, OC, DS, DI, NL, DT, & TKG
        end
        --Battle/Combat Lv 10
        if ReadByte(Save[game_version]+0x2810) >= 0x0A then
            WriteArray(Save[game_version]+0x2815,{10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10})
        end
        --Terra & Aqua's The Keyblade Graveyard Battle/Combat Level
        if ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x01 then
            if ReadShort(Now[game_version]+0x00) == 0x0111 and ReadByte(Save[game_version]+0x2821) ~= 0x09 then
                WriteByte(Save[game_version]+0x2821,0x09)
            end
        end
        --Skip World Cleared Animation
        if ReadByte(Save[game_version]+0x2913) ~= 0x00 then
            WriteByte(Save[game_version]+0x2913,0x00)
        end
        --Open All Worlds
        if ReadShort(Now[game_version]+0x00) == 0x0111 then
            read_world_item()
            WriteByte(Save[game_version]+0x2938,0x02 * worlds_unlocked_array[1]) --The Land of Departure
            WriteByte(Save[game_version]+0x293C,0x02 * worlds_unlocked_array[2]) --Dwarf Woodlands
            WriteByte(Save[game_version]+0x2940,0x02 * worlds_unlocked_array[3]) --Castle of Dreams
            WriteByte(Save[game_version]+0x2944,0x02 * worlds_unlocked_array[4]) --Enchanted Dominion
            WriteByte(Save[game_version]+0x2948,0x02 * worlds_unlocked_array[5]) --The Mysterious Tower
            WriteByte(Save[game_version]+0x294C,0x02 * worlds_unlocked_array[6]) --Radiant Garden
            WriteByte(Save[game_version]+0x2954,0x02 * worlds_unlocked_array[8]) --Olympus Coliseum
            WriteByte(Save[game_version]+0x2958,0x02 * worlds_unlocked_array[9]) --Deep Space
            if ReadByte(Save[game_version]+0x10) == 0x01 then
                WriteByte(Save[game_version]+0x295C,0x02 * worlds_unlocked_array[10]) --Destiny Islands
            end
            WriteByte(Save[game_version]+0x2960,0x02 * worlds_unlocked_array[11]) --Never Land
            WriteByte(Save[game_version]+0x2964,0x02 * worlds_unlocked_array[12]) --Disney Town
            WriteByte(Save[game_version]+0x2968,0x02 * math.floor(read_number_of_wayfinders() / 3)) --Keyblade Graveyard
            WriteByte(Save[game_version]+0x2970,0x02 * worlds_unlocked_array[7]) --Mirage Arena
            WriteArray(Save[game_version]+0x2974,{0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01}) --World Map Lines
            WriteByte(Save[game_version]+0x22E,0x01) --The Land of Departure: Mountain Path (Destroyed) MAP
            WriteByte(Save[game_version]+0x234,0x01) --The Land of Departure: Summit (Destroyed) MAP
            WriteInt(Save[game_version]+0x2984,0x00000000) --Unlock The Land of Departure: Summit (Destroyed) Save Point on World Map
            if ReadByte(Save[game_version]+0x2917) == 0x00 then
                WriteByte(Save[game_version]+0x2917,ReadByte(Save[game_version]+0x2917)+8) --Unlock The Keyblade Graveyard: Fissure Save Point on World Map
            end
        end
        --100 Acre Wood Book (Ventus & Aqua)
        if ReadByte(Save[game_version]+0x10) <= 0x01 then
            if ReadShort(Now[game_version]+0) == 0x0806 and ReadByte(Now[game_version]+8) == 0x02 then
                WriteByte(Book[game_version]+0,1)
            end
        end
        --Rumble Racing in Mirage Arena
        if ReadByte(Save[game_version]+0x269C) == 0x00 and ReadByte(Save[game_version]+0x125DC) ~= 0x00 then
            WriteInt(Save[game_version]+0x125DC,0)
            WriteInt(Save[game_version]+0x125E4,0)
        end
        if ReadByte(Save[game_version]+0x269C) == 0x01 and ReadByte(Save[game_version]+0x125DC) == 0x00 then
            WriteByte(Save[game_version]+0x125DC,1)
        end
        if ReadByte(Save[game_version]+0x125DD) == 0x00 and ReadByte(Save[game_version]+0x125E4) == 0x01 then
            WriteByte(Save[game_version]+0x125DD,1)
        end
        if ReadByte(Save[game_version]+0x125DE) == 0x00 and ReadByte(Save[game_version]+0x125E5) == 0x01 then
            WriteByte(Save[game_version]+0x125DE,1)
        end
        if ReadByte(Save[game_version]+0x125DF) == 0x00 and ReadByte(Save[game_version]+0x125E6) == 0x01 then
            WriteByte(Save[game_version]+0x125DF,1)
        end
        --Floating Flora
        if ReadShort(Now[game_version]+0x0) == 0x030D and ReadByte(Save[game_version]+0x13E4) ~= 0x16 then
            WriteByte(Save[game_version]+0x13E0,0x19)
            WriteByte(Save[game_version]+0x13E4,0x16)
        end
        --Vanitas Remnant
        if ReadByte(Save[game_version]+0x10) == 0x01 or ReadByte(Save[game_version]+0x10) == 0x02 or ReadByte(Save[game_version]+0x10) == 0x00 and ReadByte(Save[game_version]+0x26BC) == 0x01 then
            if ReadByte(Save[game_version]+0x13DA) ~= 0x01 or ReadByte(Save[game_version]+0x13DE) ~= 0x16 then
                WriteByte(Save[game_version]+0x13DA,0x01) --The Keyblade Graveyard: Badlands MAP
                WriteByte(Save[game_version]+0x13DE,0x16) --The Keyblade Graveyard: Badlands EVENT
            end
        end
        --Terra's Story
        if ReadByte(Save[game_version]+0x10) == 0x02 then
            --Unlock All Worlds (New Game)
            if ReadShort(Now[game_version]+0x10) == 0x0101 and ReadShort(Now[game_version]+0x00) == 0x0111 then
                WriteByte(Save[game_version]+0x2694,0x02) --Disney Town's Story Progression
                WriteInt(Save[game_version]+0x29C0,0xFFFFFFFE) --Lock Disney Town's Save Point on World Map
                WriteShort(Save[game_version]+0x26B4,0x8003) --Keyblade Graveyard's Story Progression
                WriteInt(Save[game_version]+0x29F0,0xFFFFFFFE) --Lock Keyblade Graveyard's Save Points on World Map
            end
            --Always Have All Worlds Opened
            WriteByte(Save[game_version]+0x2938,0x02) --The Land of Departure
            if ReadByte(Save[game_version]+0x2939) == 0x34 then
                WriteByte(Save[game_version]+0x2939,0x01)
            end
            if ReadInt(Save[game_version]+0x29E4) ~= 0 then -- Always Have The Land of Departure: Summit (Destroyed) Save[game_version] Point Opened
                WriteInt(Save[game_version]+0x29E4,0)
            end
            WriteByte(Save[game_version]+0x293C,0x02 * worlds_unlocked_array[2]) --Dwarf Woodlands
            WriteByte(Save[game_version]+0x2940,0x02 * worlds_unlocked_array[3]) --Castle of Dreams
            WriteByte(Save[game_version]+0x2944,0x02 * worlds_unlocked_array[4]) --Enchanted Dominion
            WriteByte(Save[game_version]+0x2948,0x02 * worlds_unlocked_array[5]) --The Mysterious Tower
            WriteByte(Save[game_version]+0x294C,0x02 * worlds_unlocked_array[6]) --Radiant Garden
            WriteByte(Save[game_version]+0x2954,0x02 * worlds_unlocked_array[8]) --Olympus Coliseum
            WriteByte(Save[game_version]+0x2958,0x02 * worlds_unlocked_array[9]) --Deep Space
            WriteByte(Save[game_version]+0x295C,0x00 * worlds_unlocked_array[10]) --Destiny Islands
            WriteByte(Save[game_version]+0x2960,0x02 * worlds_unlocked_array[11]) --Never Land
            WriteByte(Save[game_version]+0x2964,0x02 * worlds_unlocked_array[12]) --Disney Town
            WriteByte(Save[game_version]+0x2968,0x02 * math.floor(read_number_of_wayfinders() / 3)) --Keyblade Graveyard
            if ReadByte(Save[game_version]+0x2969) ~= 0x21 then
                WriteByte(Save[game_version]+0x2969,0x21)
            end
            WriteByte(Save[game_version]+0x2970,0x02 * worlds_unlocked_array[7]) --Mirage Arena
            --All Tutorials Viewed (Except Command Styles & Mini-Games)
            if ReadShort(Now[game_version]+0) == 0x0201 then
                WriteLong(Save[game_version]+0x4E13,0x0003030303030303)
                WriteInt(Save[game_version]+0x4E1C,0x07000007)
                WriteShort(Save[game_version]+0x4E20,0x0000)
                WriteLong(Save[game_version]+0x4E25,0x0F0F000B00000707)
                WriteShort(Save[game_version]+0x4E2D,0x1313)
            end
             --Start of Enchanted Dominion
             if ReadShort(Now[game_version]+0) == 0x704 and ReadShort(Now[game_version]+8) == 0x3D then
                if ReadByte(Save[game_version]+0x2598) == 0 then
                    WriteByte(Save[game_version]+0x2598,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Enchanted Dominion
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0904 then
                if ReadByte(Save[game_version]+0x259C) == 0 then
                    WriteByte(Save[game_version]+0x259C,1)
                    WriteArray(Now[game_version]+0,{0x04, 0x08, 0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2945,0x0122)
                    WriteShort(Save[game_version]+0x14,0x0804)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Castle of Dreams
            if ReadShort(Now[game_version]+0) == 0x603 and ReadShort(Now[game_version]+8) == 0x37 then
                if ReadByte(Save[game_version]+0x2578) == 0 then
                    WriteByte(Save[game_version]+0x2578,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Castle of Dreams
            if ReadShort(Now[game_version]+0) == 0x0111 or ReadShort(Now[game_version]+0) == 0x0B06 then
                if ReadShort(Now[game_version]+0x10) == 0x0A03 then
                    if ReadByte(Save[game_version]+0x257C) == 0 then
                        WriteByte(Save[game_version]+0x257C,1)
                        WriteArray(Now[game_version]+0,{0x03, 0x08, 0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                        WriteShort(Save[game_version]+0x2941,0x0122)
                        WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                    end
                end
            end
            --Start of Dwarf Woodlands
            if ReadShort(Now[game_version]+0) == 0x402 and ReadShort(Now[game_version]+8) == 0x35 then
                if ReadByte(Save[game_version]+0x2558) == 0 then
                    WriteByte(Save[game_version]+0x2558,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Dwarf Woodlands 1
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadInt(Now[game_version]+0x10) == 0x00000402 then
                if ReadByte(Save[game_version]+0x255C) == 0 then
                    WriteByte(Save[game_version]+0x255C,1)
                    WriteArray(Now[game_version]+0,{0x02, 0x04, 0x63, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x293D,0x0122)
                    WriteShort(Save[game_version]+0x14,0x0402)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --End of Dwarf Woodlands 2
            if ReadShort(Now[game_version]+0) == 0x0111 or ReadShort(Now[game_version]+0) == 0x0B06 then
                if ReadInt(Now[game_version]+0x10) == 0x00000602 then
                    if ReadByte(Save[game_version]+0x255C) == 0 then
                        WriteByte(Save[game_version]+0x255C,1)
                        WriteArray(Now[game_version]+0,{0x02, 0x06, 0x63, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                        WriteShort(Save[game_version]+0x293D,0x0122)
                        WriteShort(Save[game_version]+0x14,0x0602)
                        WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                    end
                end
            end
            --Start of The Mysterious Tower
            if ReadShort(Now[game_version]+0) == 0x205 and ReadShort(Now[game_version]+8) == 0x33 then
                if ReadByte(Save[game_version]+0x25B8) == 0 then
                    WriteByte(Save[game_version]+0x25B8,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of The Mysterious Tower
            if ReadShort(Now[game_version]+0) == 0x3207 and ReadShort(Now[game_version]+0x10) == 0x0405 then
                if ReadByte(Save[game_version]+0x25BC) == 0 then
                    WriteByte(Save[game_version]+0x25BC,1)
                    WriteArray(Now[game_version]+0,{0x05, 0x04, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2949,0x0122)
                    WriteShort(Save[game_version]+0x14,0x0405)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Radiant Garden
            if ReadShort(Now[game_version]+0) == 0x306 and ReadShort(Now[game_version]+8) == 0x39 then
                if ReadByte(Save[game_version]+0x25D8) == 0 then
                    WriteByte(Save[game_version]+0x25D8,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --100 Acre Wood Book (Terra)
            if ReadShort(Now[game_version]+0) == 0x0806 and ReadByte(Now[game_version]+8) == 0x00 then
                WriteByte(Book[game_version]+0,1)
            end
            --End of Radiant Garden
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0B06 then
                if ReadByte(Save[game_version]+0x25DC) == 0 then
                    WriteByte(Save[game_version]+0x25DC,1)
                    WriteArray(Now[game_version]+0,{0x06, 0x0C, 0x01, 0x00, 0x19, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x294D,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Disney Town
            if ReadShort(Now[game_version]+0) == 0x40C and ReadShort(Now[game_version]+8) == 0x50 then
                if ReadByte(Save[game_version]+0x2698) == 0 then
                    WriteByte(Save[game_version]+0x2698,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Disney Town 1
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x050C then
                WriteArray(Now[game_version]+0,{0x0C, 0x02, 0x00, 0x00, 0x4E, 0x00, 0x4E, 0x00, 0x4E})
            end
            --End of Disney Town 2
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0B0C then
                if ReadByte(Save[game_version]+0x269C) == 0 then
                    WriteByte(Save[game_version]+0x269C,1)
                    WriteArray(Now[game_version]+0,{0x0C, 0x02, 0x33, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2965,0x0122)
                    WriteShort(Save[game_version]+0x14,0x020C)
                    WriteByte(Save[game_version]+0x282C,ReadByte(Save[game_version]+0x282C)+1) --Moogle Level
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Olympus Coliseum
            if ReadShort(Now[game_version]+0) == 0x508 and ReadShort(Now[game_version]+8) == 0x3F then
                if ReadByte(Save[game_version]+0x2618) == 0 then
                    WriteByte(Save[game_version]+0x2618,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Olympus Coliseum
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0408 then
                if ReadByte(Save[game_version]+0x261C) == 0 then
                    WriteByte(Save[game_version]+0x261C,1)
                    WriteArray(Now[game_version]+0,{0x08, 0x02, 0x32, 0x00, 0x02, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2955,0x0122)
                    WriteShort(Save[game_version]+0x14,0x0208)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Deep Space
            if ReadShort(Now[game_version]+0) == 0x109 and ReadShort(Now[game_version]+8) == 0x1 then
                if ReadByte(Save[game_version]+0x2638) == 0 then
                    WriteByte(Save[game_version]+0x2638,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Deep Space
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0609 then
                if ReadByte(Save[game_version]+0x263C) == 0 then
                    WriteByte(Save[game_version]+0x263C,1)
                    WriteArray(Now[game_version]+0,{0x09, 0x06, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2959,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Never Land
            if ReadShort(Now[game_version]+0) == 0xB0B and ReadShort(Now[game_version]+8) == 0x39 then
                if ReadByte(Save[game_version]+0x2658) == 0 then
                    WriteByte(Save[game_version]+0x2658,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Never Land
            if ReadShort(Now[game_version]+0) == 0x3207 and ReadShort(Now[game_version]+0x10) == 0x0D0B then
                if ReadByte(Save[game_version]+0x265C) == 0 then
                    WriteByte(Save[game_version]+0x265C,1)
                    WriteArray(Now[game_version]+0,{0x0B, 0x0D, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2961,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Destiny Islands
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadByte(Save[game_version]+0x2658) == 0x0A then
                WriteArray(Now[game_version]+0,{0x07, 0x32, 0x00, 0x00, 0x34, 0x00, 0x34, 0x00, 0x34})
                WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
            end
            --Xehanort Visit
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadByte(Save[game_version]+0x2658) == 0x0B then
                WriteArray(Now[game_version]+0,{0x0D, 0x01, 0x00, 0x00, 0x37, 0x00, 0x37, 0x00, 0x37})
                WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
            end
            --End of Xehanort Visit
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadInt(Now[game_version]+0x10) == 0x000A010D then
                WriteArray(Now[game_version]+0,{0x0D, 0x01, 0x63, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                WriteShort(Save[game_version]+0x14,0x010D)
            end
            --Normal Land of Departure Text
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadByte(Save[game_version]+0x26BC) == 0x00 then
                WriteString(RoomNameText[game_version]+0xDC,"Eraqus")
            end
            --Master Eraqus Fight
            if ReadInt(Now[game_version]+0) == 0x00631001 and ReadByte(Save[game_version]+0x26BC) == 0x00 then
                WriteArray(Now[game_version]+0,{0x01, 0x01, 0x00, 0x00, 0x41, 0x00, 0x41, 0x00, 0x41})
            end
            --End of The Land of Departure
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0801 then
                if ReadByte(Save[game_version]+0x253C) == 0 then
                    WriteByte(Save[game_version]+0x253C,1)
                    WriteArray(Now[game_version]+0,{0x01, 0x0F, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2939,0x0222)
                    WriteByte(Save[game_version]+0x26BC,0x01)
                    WriteInt(Save[game_version]+0x2988,0x00000000)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Normal Summit -> Destroyed Summit (Post Master Eraqus Battle)
            if ReadShort(Now[game_version]+0) == 0x0601 and ReadShort(Now[game_version]+0x10) == 0x0111 and ReadByte(Save[game_version]+0x26BC) == 0x01 then
                WriteArray(Now[game_version]+0,{0x01, 0x10, 0x63, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
            end
            --Destroyed Land of Departure Text
            if ReadByte(Save[game_version]+0x26BC) == 0x01 then
                if ReadShort(Now[game_version]+0) == 0x0111 then
                    WriteString(RoomNameText[game_version]+0xDC,"? ? ? ")
                else
                    WriteString(RoomNameText[game_version]+0xDC,"Summit")
                end
            end
            --??? Fight
            if ReadInt(Now[game_version]+0) == 0x00631001 and ReadShort(Now[game_version]+0x30) == 0x1001 and ReadShort(Save[game_version]+0x26BC) == 0x01 then
                WriteArray(Now[game_version]+2,{0x00, 0x00, 0x43, 0x00, 0x43, 0x00, 0x43})
            end
            --The Keyblade Graveyard: Fissure Room Name
            if ReadByte(Save[game_version]+0x26B8) == 0x00 then
                WriteString(RoomNameText[game_version]+0x9DD,"Seat of War") --Changes The Keyblade Graveyard: Fissure's Room Name
                WriteByte(RoomNameText[game_version]+0x9E8,0x00) --Makes sure Room Name text doesn't overlap
            else
                WriteString(RoomNameText[game_version]+0x9DD,"Fissure") --Fixes Room Name text back to normal
                WriteArray(RoomNameText[game_version]+0x9E4,{0x00, 0x4B, 0x65, 0x79, 0x62})
            end
            --Start of The Keyblade Graveyard
            if ReadShort(Now[game_version]+0) == 0x070D and ReadShort(RoomNameText[game_version]+0x9DD) == 0x6553 then
                WriteArray(Now[game_version]+0,{0x0D, 0x02, 0x00, 0x00, 0x46, 0x00, 0x46, 0x00, 0x46})
                WriteByte(Save[game_version]+0x26B8,0x01)
            end
            --[[Final Battle Requirements
            if ReadShort(Now[game_version]+0) == 0x080D then 
                if ReadInt(Save[game_version]+0x32B8) == 0x1F1F1F1C and ReadShort(Save[game_version]+0x32BC) == 0x1F20 then
                    WriteShort(Now[game_version]+0,0x080D)
                else
                    WriteInt(Now[game_version]+0,0x0032070D)
                end
            end]]
        end
        --Ventus's Story
        if ReadByte(Save[game_version]+0x10) == 0x00 then
            --Unlock All Worlds (New Game)
            if ReadShort(Now[game_version]+0x10) == 0x0101 and ReadShort(Now[game_version]+0) == 0x0111 then
                WriteLong(Save[game_version]+0x2990,0xFFFFFFFEFFFFFFFE) --Lock The Land of Departure's Save[game_version] Points on World Map
                WriteInt(Save[game_version]+0x2998,0x02140000) -- Lock The Land of Departure: Forecourt Ruins
                WriteInt(Save[game_version]+0x29D0,0xFFFFFFFE) --Lock The Mysterious Tower's Save[game_version] Point on World Map
            end
            --Always Have All Worlds Opened
            WriteByte(Save[game_version]+0x2938,0x02) --The Land of Departure
            if ReadByte(Save[game_version]+0x2939) == 0x34 then
                    WriteByte(Save[game_version]+0x2939,0x01)
                end
            WriteByte(Save[game_version]+0x293C,0x02 * worlds_unlocked_array[2]) --Dwarf Woodlands
            WriteByte(Save[game_version]+0x2940,0x02 * worlds_unlocked_array[3]) --Castle of Dreams
            WriteByte(Save[game_version]+0x2944,0x02 * worlds_unlocked_array[4]) --Enchanted Dominion
            WriteByte(Save[game_version]+0x2948,0x02 * worlds_unlocked_array[5]) --The Mysterious Tower
            WriteByte(Save[game_version]+0x294C,0x02 * worlds_unlocked_array[6]) --Radiant Garden
            WriteByte(Save[game_version]+0x2954,0x02 * worlds_unlocked_array[8]) --Olympus Coliseum
            WriteByte(Save[game_version]+0x2958,0x02 * worlds_unlocked_array[9]) --Deep Space
            WriteByte(Save[game_version]+0x295C,0x00 * worlds_unlocked_array[10]) --Destiny Islands
            WriteByte(Save[game_version]+0x2960,0x02 * worlds_unlocked_array[11]) --Never Land
            WriteByte(Save[game_version]+0x2964,0x02 * worlds_unlocked_array[12]) --Disney Town
            WriteByte(Save[game_version]+0x2968,0x02 * math.floor(read_number_of_wayfinders() / 3)) --Keyblade Graveyard
            if ReadByte(Save[game_version]+0x2969) ~= 0x21 then
                WriteByte(Save[game_version]+0x2969,0x21)
            end
            WriteByte(Save[game_version]+0x2970,0x02 * worlds_unlocked_array[7]) --Mirage Arena
            --All Tutorials Viewed (Except Command Styles & Mini-Games)
            if ReadShort(Now[game_version]+0) == 0x0201 then
                WriteLong(Save[game_version]+0x4E13,0x0703030303030303)
                WriteInt(Save[game_version]+0x4E1D,0x07000007)
                WriteByte(Save[game_version]+0x4E21,0x07)
                WriteShort(Save[game_version]+0x4E26,0x0707)
                WriteArray(Save[game_version]+0x4E29,{0x0B, 0x00, 0x0F, 0x0F, 0x13, 0x13})
            end
            --Start of Dwarf Woodlands
            if ReadShort(Now[game_version]+0) == 0xC02 and ReadShort(Now[game_version]+8) == 0x3A then
                if ReadByte(Save[game_version]+0x2558) == 0 then
                    WriteByte(Save[game_version]+0x2558,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Dwarf Woodlands
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0702 then
                if ReadByte(Save[game_version]+0x255C) == 0 then
                    WriteByte(Save[game_version]+0x255C,1)
                    WriteArray(Now[game_version]+0,{0x02, 0x07, 0x01, 0x00, 0x01, 0x00, 0x18, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x293D,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Castle of Dreams
            if ReadShort(Now[game_version]+0) == 0x103 and ReadShort(Now[game_version]+8) == 0x3A then
                if ReadByte(Save[game_version]+0x2578) == 0 then
                    WriteByte(Save[game_version]+0x2578,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Castle of Dreams
            if ReadShort(Now[game_version]+0) == 0x0111 or ReadShort(Now[game_version]+0) == 0x3207 then
                if ReadInt(Now[game_version]+0x10) == 0x00000103 then
                    if ReadByte(Save[game_version]+0x257C) == 0 then
                        WriteByte(Save[game_version]+0x257C,1)
                        WriteArray(Now[game_version]+0,{0x03, 0x01, 0x63, 0x00, 0x04, 0x00, 0x00, 0x00, 0x16})
                        WriteShort(Save[game_version]+0x2941,0x0122)
                        WriteShort(Save[game_version]+0x14,0x0103)
                        WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                    end
                end
            end
            --Start of Enchanted Dominion
            if ReadShort(Now[game_version]+0) == 0xF04 and ReadShort(Now[game_version]+8) == 0x3C then
                if ReadByte(Save[game_version]+0x2598) == 0 then
                    WriteByte(Save[game_version]+0x2598,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Enchanted Dominion
            if ReadShort(Now[game_version]+0) == 0x0111 or ReadShort(Now[game_version]+0) == 0x3207 then
                if ReadShort(Now[game_version]+0x10) == 0x0204 then
                    if ReadByte(Save[game_version]+0x259C) == 0 then
                        WriteByte(Save[game_version]+0x259C,1)
                        WriteArray(Now[game_version]+0,{0x04, 0x06, 0x01, 0x00, 0x01, 0x00, 0x18, 0x00, 0x16})
                        WriteShort(Save[game_version]+0x2945,0x0122)
                        WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                    end
                end
            end
            --Start of Radiant Garden
            if ReadShort(Now[game_version]+0) == 0x0306 and ReadShort(Now[game_version]+8) == 0x40 then
                if ReadByte(Save[game_version]+0x25D8) == 0 then
                    WriteByte(Save[game_version]+0x25D8,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Radiant Garden
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0306 then
                if ReadByte(Save[game_version]+0x25DC) == 0 then
                    WriteByte(Save[game_version]+0x25DC,1)
                    WriteArray(Now[game_version]+0,{0x06, 0x03, 0x34, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x294D,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Disney Town
            if ReadShort(Now[game_version]+0) == 0x20C and ReadShort(Now[game_version]+8) == 0x55 then
                if ReadByte(Save[game_version]+0x2698) == 0 then
                    WriteByte(Save[game_version]+0x2698,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                    WriteByte(Save[game_version]+0x1276,0x00)
                    WriteByte(Save[game_version]+0x12A0,0x00)
                end
            end
            --End of Disney Town 1
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadInt(Now[game_version]+0x10) == 0x0000020C then
                WriteArray(Now[game_version]+0,{0x0C, 0x02, 0x00, 0x00, 0x54, 0x00, 0x54, 0x00, 0x54})
            end
            --End of Disney Town 2
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0B0C then
                if ReadByte(Save[game_version]+0x269C) == 0 then
                    WriteByte(Save[game_version]+0x269C,1)
                    WriteArray(Now[game_version]+0,{0x0C, 0x02, 0x33, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2965,0x0122)
                    WriteShort(Save[game_version]+0x14,0x020C)
                    WriteByte(Save[game_version]+0x282C,ReadByte(Save[game_version]+0x282C)+1) --Moogle Level
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                    WriteByte(Save[game_version]+0x1276,0x16)
                    WriteByte(Save[game_version]+0x12A0,0x16)
                end
            end
            --Start of Olympus Coliseum
            if ReadShort(Now[game_version]+0) == 0x508 and ReadShort(Now[game_version]+8) == 0x40 then
                if ReadByte(Save[game_version]+0x2618) == 0 then
                    WriteByte(Save[game_version]+0x2618,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Olympus Coliseum
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0508 then
                if ReadByte(Save[game_version]+0x261C) == 0 then
                    WriteByte(Save[game_version]+0x261C,1)
                    WriteArray(Now[game_version]+0,{0x08, 0x05, 0x00, 0x00, 0x19, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2955,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Deep Space
            if ReadShort(Now[game_version]+0) == 0x609 and ReadShort(Now[game_version]+8) == 0x1 then
                if ReadByte(Save[game_version]+0x2638) == 0 then
                    WriteByte(Save[game_version]+0x2638,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Deep Space
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0B09 then
                if ReadByte(Save[game_version]+0x263C) == 0 then
                    WriteByte(Save[game_version]+0x263C,1)
                    WriteArray(Now[game_version]+0,{0x09, 0x09, 0x03, 0x00, 0x19, 0x00, 0x18, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2959,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Never Land
            if ReadShort(Now[game_version]+0) == 0x40B and ReadShort(Now[game_version]+8) == 0x1 then
                if ReadByte(Save[game_version]+0x2658) == 0 then
                    WriteByte(Save[game_version]+0x2658,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Never Land
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadInt(Now[game_version]+0x10) == 0x0000010B then
                if ReadByte(Save[game_version]+0x265C) == 0 then
                    WriteByte(Save[game_version]+0x265C,1)
                    WriteArray(Now[game_version]+0,{0x0B, 0x01, 0x63, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2961,0x0122)
                    WriteShort(Save[game_version]+0x14,0x010B)
                    WriteShort(Save[game_version]+0x19DE,0x0000)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of The Mysterious Tower 1
            if ReadShort(Now[game_version]+0) == 0x0105 and ReadShort(Now[game_version]+0x10) == 0x0111 then
                WriteArray(Now[game_version]+0,{0x05, 0x02, 0x00, 0x00, 0x36, 0x00, 0x36, 0x00, 0x36})
            end
            --Start of The Mysterious Tower 2
            if ReadShort(Now[game_version]+0) == 0x205 and ReadShort(Now[game_version]+8) == 0x36 then
                if ReadByte(Save[game_version]+0x25B8) == 0 then
                    WriteByte(Save[game_version]+0x25B8,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of The Mysterious Tower
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0105 then
                if ReadByte(Save[game_version]+0x25BC) == 0 then
                    WriteByte(Save[game_version]+0x25BC,1)
                    WriteArray(Now[game_version]+0,{0x05, 0x04, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2949,0x0122)
                    WriteShort(Save[game_version]+0x14,0x0405)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Land of Departure & Destiny Islands 1
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadByte(Save[game_version]+0x2658) == 0x0A then
                WriteShort(Save[game_version]+0x19DE,0x01)
                WriteShort(Now[game_version]+8,0x01)
            end
            --Land of Departure & Destiny Islands 2
            if ReadShort(Now[game_version]+0) == 0x0205 and ReadShort(Save[game_version]+0x19DE) == 0x0001 then
                WriteArray(Now[game_version]+0,{0x0D, 0x01, 0x00, 0x00, 0x40, 0x00, 0x40, 0x00, 0x40})
                WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
            end
            --Land of Departure & Destiny Islands 3
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadByte(Save[game_version]+0x2658) == 0x0B then
                WriteArray(Now[game_version]+0,{0x01, 0x01, 0x00, 0x00, 0x48, 0x00, 0x48, 0x00, 0x48})
                WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
            end
            --Land of Departure & Destiny Islands 4
            if ReadShort(Now[game_version]+0) == 0x010A and ReadShort(Now[game_version]+8) == 0x0038 then
                WriteShort(Save[game_version]+0x2939,0x0222)
                WriteShort(Save[game_version]+0x19DE,0x0000)
                WriteInt(Save[game_version]+0x2990,0x00000000)
            end
            --Normal Summit -> Destroyed Summit (Post Destiny Islands)
            if ReadShort(Now[game_version]+0) == 0x0601 and ReadShort(Save[game_version]+0x2939) == 0x0222 then
                WriteArray(Now[game_version]+0,{0x01, 0x10, 0x63, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
            end
            --Destroyed Land of Departure Text
            if ReadShort(Now[game_version]+0) == 0x0111 then
                WriteString(RoomNameText[game_version]+0xDC,"? ? ? ")
            else
                WriteString(RoomNameText[game_version]+0xDC,"Summit")
            end
            --??? Fight
            if ReadInt(Now[game_version]+0) == 0x00631001 and ReadShort(Now[game_version]+0x30) == 0x1001 then
                WriteArray(Now[game_version]+2,{0x00, 0x00, 0x49, 0x00, 0x49, 0x00, 0x49})
            end
            --Pre-Vanitas I Fight 1
            if ReadInt(Now[game_version]+0) == 0x0063010D and ReadByte(Save[game_version]+0x26B8) == 0 then
                WriteArray(Now[game_version]+0,{0x07, 0x32, 0x00, 0x00, 0x3A, 0x00, 0x3A, 0x00, 0x3A})
            end
            --Pre-Vanitas I Fight 2
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadInt(Now[game_version]+0x10) == 0x00003207 then
                if ReadByte(Save[game_version]+0x26B8) == 0 then
                    WriteByte(Save[game_version]+0x26B8,1)
                    WriteLong(Save[game_version]+0x2815,ReadLong(Save[game_version]+0x2815)+0x0101010101010101)
                    WriteInt(Save[game_version]+0x281D,ReadInt(Save[game_version]+0x281D)+0x01010101)
                    WriteByte(Save[game_version]+0x2821,ReadByte(Save[game_version]+0x2821)+1)
                    WriteArray(Now[game_version]+0,{0x0D, 0x01, 0x00, 0x00, 0x35, 0x00, 0x35, 0x00, 0x35})
                end
            end
            --Post Vanitas I Fight
            if ReadShort(Now[game_version]+0) == 0x3207 and ReadShort(Now[game_version]+0x10) == 0x010D then
                if ReadByte(Save[game_version]+0x26BC) == 0 then
                    WriteByte(Save[game_version]+0x26BC,1)
                    WriteInt(Save[game_version]+0x2A04,0x00000000)
                    WriteByte(Save[game_version]+0x13DA,0x01) --The Keyblade Graveyard: Badlands MAP
                    WriteByte(Save[game_version]+0x13DE,0x16) --The Keyblade Graveyard: Badlands EVENT
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --The Keyblade Graveyard: Fissure Room Name
            if ReadByte(Save[game_version]+0x26B5) < 0x08 then
                WriteString(RoomNameText[game_version]+0x9DD,"Seat of War") --Changes The Keyblade Graveyard: Fissure's Room Name
                WriteByte(RoomNameText[game_version]+0x9E8,0x00) --Makes sure Room Name text doesn't overlap
            else
                WriteString(RoomNameText[game_version]+0x9DD,"Fissure") --Fixes Room Name text back to normal
                WriteArray(RoomNameText[game_version]+0x9E4,{0x00, 0x4B, 0x65, 0x79, 0x62})
            end
            --Start of The Keyblade Graveyard
            if ReadShort(Now[game_version]+0) == 0x070D and ReadShort(RoomNameText[game_version]+0x9DD) == 0x6553 then
                WriteArray(Now[game_version]+0,{0x0D, 0x02, 0x00, 0x00, 0x42, 0x00, 0x42, 0x00, 0x42})
            end
            --Start of Final Battles
            if ReadShort(Now[game_version]+0) == 0x080D and ReadShort(Save[game_version]+0x26BC) == 0 then
                WriteByte(Save[game_version]+0x2821,9)
            end
            --[[Final Battle Requirements
            if ReadShort(Now[game_version]+0) == 0x080D then 
                if ReadInt(Save[game_version]+0x32B8) == 0x1F1F1F1C and ReadShort(Save[game_version]+0x32BC) == 0x1F20 then
                    WriteShort(Now[game_version]+0,0x080D)
                else
                    WriteInt(Now[game_version]+0,0x0032070D)
                end
            end]]
        end
        --Aqua's Story
        if ReadByte(Save[game_version]+0x10) == 0x01 then
            --Makes The Mysterious Tower not "clear" when entering Final Episode
            if ReadShort(Now[game_version]+0x10) == 0x0101 and ReadShort(Now[game_version]+0) == 0x0111 then
                WriteShort(Save[game_version]+0x2875,0x04C0)
            end
            --Always Have All Worlds Opened
            WriteByte(Save[game_version]+0x2938,0x02) --The Land of Departure
            if ReadByte(Save[game_version]+0x2939) == 0x34 then
                WriteByte(Save[game_version]+0x2939,0x01)
            end
            WriteByte(Save[game_version]+0x293C,0x02 * worlds_unlocked_array[2]) --Dwarf Woodlands
            WriteByte(Save[game_version]+0x2940,0x02 * worlds_unlocked_array[3]) --Castle of Dreams
            WriteByte(Save[game_version]+0x2944,0x02 * worlds_unlocked_array[4]) --Enchanted Dominion
            WriteByte(Save[game_version]+0x2948,0x02 * worlds_unlocked_array[5]) --The Mysterious Tower
            WriteByte(Save[game_version]+0x294C,0x02 * worlds_unlocked_array[6]) --Radiant Garden
            WriteByte(Save[game_version]+0x2954,0x02 * worlds_unlocked_array[8]) --Olympus Coliseum
            WriteByte(Save[game_version]+0x2958,0x02 * worlds_unlocked_array[9]) --Deep Space
            WriteByte(Save[game_version]+0x295C,0x02 * worlds_unlocked_array[10]) --Destiny Islands
            if ReadByte(Save[game_version]+0x25F5) == 0x00 then
                WriteByte(Save[game_version]+0x295D,0x08)
            elseif ReadByte(Save[game_version]+0x25F5) == 0x01 then
                WriteByte(Save[game_version]+0x295D,0x01)
            end
            WriteByte(Save[game_version]+0x2960,0x02 * worlds_unlocked_array[11]) --Never Land
            WriteByte(Save[game_version]+0x2964,0x02 * worlds_unlocked_array[12]) --Disney Town
            WriteByte(Save[game_version]+0x2968,0x02 * math.floor(read_number_of_wayfinders() / 3)) --Keyblade Graveyard
            if ReadByte(Save[game_version]+0x2969) ~= 0x21 then
                WriteByte(Save[game_version]+0x2969,0x21)
            end
            WriteByte(Save[game_version]+0x2970,0x02 * worlds_unlocked_array[7]) --Mirage Arena
            WriteLong(Save[game_version]+0x298C,0x0000000000000000) --Unlock The Land of Departure's Save Points on World Map
            WriteInt(Save[game_version]+0x29F0,0x00000000) --Unlock The Keyblade Graveyard: Badlands Save Point on World Map
            WriteString(RoomNameText[game_version]+0x77C,"Realm of Darkness")
            WriteByte(RoomNameText[game_version]+0x78D,0x00)
            --All Tutorials Viewed (Except Command Styles & Mini-Games)
            if ReadShort(Now[game_version]+0) == 0x0201 then
                WriteArray(Save[game_version]+0x4E13,{0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x00, 0x07, 0x00, 0x00, 0x07})
                WriteInt(Save[game_version]+0x4E20,0x07070000)
                WriteInt(Save[game_version]+0x4E26,0x0B000007)
                WriteInt(Save[game_version]+0x4E2B,0x13130F0F)
            end
            --Start of Castle of Dreams
            if ReadShort(Now[game_version]+0) == 0xA03 and ReadShort(Now[game_version]+8) == 0x3D then
                if ReadByte(Save[game_version]+0x2578) == 0 then
                    WriteByte(Save[game_version]+0x2578,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Castle of Dreams
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadInt(Now[game_version]+0x10) == 0x00000703 then
                if ReadByte(Save[game_version]+0x257C) == 0 then
                    WriteByte(Save[game_version]+0x257C,1)
                    WriteArray(Now[game_version]+0,{0x03, 0x07, 0x32, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2941,0x0122)
                    WriteShort(Save[game_version]+0x14,0x0703)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Dwarf Woodlands
            if ReadShort(Now[game_version]+0) == 0xB02 and ReadShort(Now[game_version]+8) == 0x3C then
                if ReadByte(Save[game_version]+0x2558) == 0 then
                    WriteByte(Save[game_version]+0x2558,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Dwarf Woodlands
            if ReadShort(Now[game_version]+0) == 0x0111 or ReadShort(Now[game_version]+0) == 0x3207 or ReadShort(Now[game_version]+0) == 0x0B06 then
                if ReadInt(Now[game_version]+0x10) == 0x00000A02 then
                    if ReadByte(Save[game_version]+0x255C) == 0 then
                        WriteByte(Save[game_version]+0x255C,1)
                        WriteArray(Now[game_version]+0,{0x02, 0x0A, 0x63, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                        WriteShort(Save[game_version]+0x293D,0x0122)
                        WriteShort(Save[game_version]+0x14,0x0A02)
                        WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                    end
                end
            end
            --Start of Enchanted Dominion
            if ReadShort(Now[game_version]+0) == 0x604 and ReadShort(Now[game_version]+8) == 0x3B then
                if ReadByte(Save[game_version]+0x2598) == 0 then
                    WriteByte(Save[game_version]+0x2598,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Enchanted Dominion
            if ReadShort(Now[game_version]+0) == 0x0111 or ReadShort(Now[game_version]+0) == 0x3207 or ReadShort(Now[game_version]+0) == 0x0B06 then
                if ReadShort(Now[game_version]+0x10) == 0x0904 then
                    if ReadByte(Save[game_version]+0x259C) == 0 then
                        WriteByte(Save[game_version]+0x259C,1)
                        WriteArray(Now[game_version]+0,{0x04, 0x08, 0x02, 0x00, 0x02, 0x00, 0x00, 0x00, 0x16})
                        WriteShort(Save[game_version]+0x2945,0x0122)
                        WriteShort(Save[game_version]+0x14,0x0804)
                        WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                    end
                end
            end
            --Start of Radiant Garden
            if ReadShort(Now[game_version]+0) == 0x306 and ReadShort(Now[game_version]+8) == 0x4A then
                if ReadByte(Save[game_version]+0x25D8) == 0 then
                    WriteByte(Save[game_version]+0x25D8,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Radiant Garden
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0306 then
                if ReadByte(Save[game_version]+0x25DC) == 0 then
                    WriteByte(Save[game_version]+0x25DC,1)
                    WriteArray(Now[game_version]+0,{0x06, 0x03, 0x00, 0x00, 0x19, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x294D,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Disney Town
            if ReadShort(Now[game_version]+0) == 0x20C and ReadShort(Now[game_version]+8) == 0x5F then
                if ReadByte(Save[game_version]+0x2698) == 0 then
                    WriteByte(Save[game_version]+0x2698,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                    WriteByte(Save[game_version]+0x1276,0x00)
                    WriteByte(Save[game_version]+0x12A0,0x00)
                end
            end
            --Quicker Fruitball
            if ReadShort(Now[game_version]+0) == 0x0E0C and ReadInt(Timer[game_version]+0) >= 0x4628BFFF then
                WriteInt(Timer[game_version]+0,0x45610000)
            end
            --End of Disney Town 1
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x030C then
                WriteArray(Now[game_version]+0,{0x0C, 0x02, 0x00, 0x00, 0x5E, 0x00, 0x5E, 0x00, 0x5E})
            end
            --End of Disney Town 2
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0B0C then
                if ReadByte(Save[game_version]+0x269C) == 0 then
                    WriteByte(Save[game_version]+0x269C,1)
                    WriteArray(Now[game_version]+0,{0x0C, 0x02, 0x33, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2965,0x0122)
                    WriteShort(Save[game_version]+0x14,0x020C)
                    WriteByte(Save[game_version]+0x282C,ReadByte(Save[game_version]+0x282C)+1) --Moogle Level
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                    WriteByte(Save[game_version]+0x1276,0x16)
                    WriteByte(Save[game_version]+0x12A0,0x16)
                end
            end
            --Start of Olympus Coliseum
            if ReadShort(Now[game_version]+0) == 0x108 and ReadShort(Now[game_version]+8) == 0x41 then
                if ReadByte(Save[game_version]+0x2618) == 0 then
                    WriteByte(Save[game_version]+0x2618,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Olympus Coliseum
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0108 then
                if ReadByte(Save[game_version]+0x261C) == 0 then
                    WriteByte(Save[game_version]+0x261C,1)
                    WriteArray(Now[game_version]+0,{0x08, 0x01, 0x33, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00})
                    WriteShort(Save[game_version]+0x2955,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Deep Space
            if ReadShort(Now[game_version]+0) == 0x309 and ReadShort(Now[game_version]+8) == 0x3F then
                if ReadByte(Save[game_version]+0x2638) == 0 then
                    WriteByte(Save[game_version]+0x2638,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Deep Space
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0909 then
                if ReadByte(Save[game_version]+0x263C) == 0 then
                    WriteByte(Save[game_version]+0x263C,1)
                    WriteArray(Now[game_version]+0,{0x09, 0x09, 0x32, 0x00, 0x19, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2959,0x0122)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Start of Never Land
            if ReadShort(Now[game_version]+0) == 0x80B and ReadShort(Now[game_version]+8) == 0x3B then
                if ReadByte(Save[game_version]+0x2678) == 0 then
                    WriteByte(Save[game_version]+0x2678,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of Never Land
            if ReadShort(Now[game_version]+0) == 0x3207 and ReadShort(Now[game_version]+0x10) == 0x080B then
                if ReadByte(Save[game_version]+0x265C) == 0 then
                    WriteByte(Save[game_version]+0x265C,1)
                    WriteArray(Now[game_version]+0,{0x0B, 0x08, 0x01, 0x00, 0x19, 0x00, 0x19, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x2961,0x0122)
                    WriteShort(Save[game_version]+0x14,0x080B)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Destiny Islands 1
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadByte(Save[game_version]+0x2658) == 0x0A then
                WriteArray(Now[game_version]+0,{0x07, 0x32, 0x00, 0x00, 0x42, 0x00, 0x42, 0x00, 0x42})
                WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
            end
            --Destiny Islands 2
            if ReadShort(Now[game_version]+0) == 0x3207 and ReadShort(Now[game_version]+0x10) == 0x020A then
                WriteArray(Now[game_version]+0,{0x11, 0x01, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
            end
            --Start of The Mysterious Tower 1
            if ReadShort(Now[game_version]+0) == 0x0205 and ReadShort(Now[game_version]+0x10) == 0x0111 then
                WriteArray(Now[game_version]+0,{0x07, 0x32, 0x00, 0x00, 0x43, 0x00, 0x43, 0x00, 0x43})
            end
            --Start of The Mysterious Tower 2
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x3207 then
                if ReadByte(Save[game_version]+0x25B8) == 0x00 then
                    WriteArray(Now[game_version]+0,{0x05, 0x02, 0x00, 0x00, 0x34, 0x00, 0x34, 0x00, 0x34})
                    WriteByte(Save[game_version]+0x25B8,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --End of The Mysterious Tower 1
            if ReadShort(Now[game_version]+0) == 0x3207 and ReadInt(Now[game_version]+0x10) == 0x00010405 then
                if ReadByte(Save[game_version]+0x25BC) == 0x00 then
                    WriteArray(Now[game_version]+0,{0x05, 0x04, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                    WriteShort(Save[game_version]+0x14,0x0405)
                    WriteString(BGM[game_version]+0,"124dp_amb")
                end
            end
            --End of The Mysterious Tower 2
            if ReadShort(Now[game_version]+0) == 0x0111 and ReadShort(Now[game_version]+0x10) == 0x0405 then
                if ReadByte(Save[game_version]+0x25BC) == 0 then
                    WriteByte(Save[game_version]+0x25BC,1)
                    WriteArray(Now[game_version]+0,{0x07, 0x32, 0x00, 0x00, 0x44, 0x00, 0x44, 0x00, 0x44})
                    WriteShort(Save[game_version]+0x2949,0x0122)
                    WriteString(BGM[game_version]+0,"019iensid_f")
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
            end
            --Normal Land of Departure -> Destroyed Land of Departure
            if ReadByte(Save[game_version]+0x294A) == 0x01 then
                WriteByte(Save[game_version]+0x293A,0x02)
            end
            --Normal Summit -> Destroyed Summit (Post The Mysterious Tower)
            if ReadByte(Save[game_version]+0x293A) == 0x02 then
                if ReadShort(Now[game_version]+0) == 0x0601 and ReadShort(Now[game_version]+0x10) == 0x0111 then
                    WriteArray(Now[game_version]+0,{0x01, 0x10, 0x63, 0x00, 0x01, 0x00, 0x00, 0x00, 0x16})
                end
                WriteInt(Save[game_version]+0x2984,0x00000000)
            end
            --Destroyed Land of Departure Text 1
            if ReadShort(Now[game_version]+0) == 0x0111 then
                WriteString(RoomNameText[game_version]+0xDC,"? ? ? ")
            else
                WriteString(RoomNameText[game_version]+0xDC,"Summit")
            end
            --??? Fight
            if ReadInt(Now[game_version]+0) == 0x00631001 and ReadShort(Now[game_version]+0x30) == 0x1001 then
                WriteArray(Now[game_version]+2,{0x00, 0x00, 0x50, 0x00, 0x50, 0x00, 0x50})
            end
            --The Keyblade Graveyard: Fissure Room Name
            if ReadByte(Save[game_version]+0x26B4) < 0x04 then
                WriteString(RoomNameText[game_version]+0x9DD,"Seat of War") --Changes The Keyblade Graveyard: Fissure's Room Name
                WriteByte(RoomNameText[game_version]+0x9E8,0x00) --Makes sure Room Name text doesn't overlap
            else
                WriteString(RoomNameText[game_version]+0x9DD,"Fissure") --Fixes Room Name text back to normal
                WriteArray(RoomNameText[game_version]+0x9E4,{0x00, 0x4B, 0x65, 0x79, 0x62})
            end
            --Start of The Keyblade Graveyard
            if ReadShort(Now[game_version]+0) == 0x070D and ReadShort(RoomNameText[game_version]+0x9DD) == 0x6553 then
                WriteArray(Now[game_version]+0,{0x0D, 0x02, 0x00, 0x00, 0x3B, 0x00, 0x3B, 0x00, 0x3B})
            end
            --[[Final Battle Requirements
            if ReadShort(Now[game_version]+0) == 0x080D then 
                if ReadInt(Save[game_version]+0x32B8) == 0x1F1F1F1C and ReadShort(Save[game_version]+0x32BC) == 0x1F20 then
                    WriteShort(Now[game_version]+0,0x080D)
                else
                    WriteInt(Now[game_version]+0,0x0032070D)
                end
            end]]
            --No Music After Braig
            if ReadShort(Now[game_version]+0) == 0x0C0D and ReadByte(Now[game_version]+8) == 0x3C and ReadShort(BGM[game_version]+0x21) == 0x3132 then
                WriteString(BGM[game_version]+0x20,"124dp_amb")
            else
                WriteString(BGM[game_version]+0x20,"021kouya_f")
            end
            --Start of Final Episode
            if ReadShort(Now[game_version]+0) == 0x0105 and ReadShort(Now[game_version]+8) == 0x0038 then
                WriteArray(Now[game_version]+0,{0x05, 0x02, 0x00, 0x00, 0x37, 0x00, 0x37, 0x00, 0x37})
                WriteByte(Save[game_version]+0x26BC,1)
                if ReadByte(Save[game_version]+0x25D4) == 0x00 then
                    BitOr(Save[game_version]+0x2916, 0x05)
                else
                    BitOr(Save[game_version]+0x2916, 0x01)
                end
            end
            --Final Episode State
            if ReadByte(Save[game_version]+0x26BC) == 0x01 then
                if ReadByte(Save[game_version]+0x294A) == 0x00 and ReadByte (Save[game_version]+0x25B4) == 0x00 then
                    WriteByte(Save[game_version]+0x2949,0x01)
                end
                WriteInt(Save[game_version]+0x29CC,0x00000000)
                WriteLong(Save[game_version]+0x29F4,0x0000000000000000) --Re-opens Seat of War & Twister Trench
                WriteInt(Save[game_version]+0x29FC,0x00000000) --Re-opens Fissure
                if ReadByte(Now[game_version]+0) ~= 0x0F then
                    WriteByte(CharMod[game_version]+0,0x02) --Changes Character from Armored Aqua to Normal Aqua
                end
                if ReadByte(Now[game_version]+0) == 0x06 then --Room Names
                    WriteString(RoomNameText[game_version]+0x41D,"Entryway") --Fixes Room Name text back to normal
                    WriteArray(RoomNameText[game_version]+0x425,{0x00, 0x43, 0x65, 0x6E, 0x74, 0x72, 0x61, 0x6C, 0x20, 0x53, 0x71, 0x75, 0x61, 0x72})
                    WriteString(RoomNameText[game_version]+0x478,"Front Doors") --Fixes Room Name text back to normal
                    WriteArray(RoomNameText[game_version]+0x483,{0x00, 0x50, 0x75, 0x72, 0x69, 0x66, 0x69, 0x63, 0x61, 0x74})
                else
                    WriteString(RoomNameText[game_version]+0x41D,"Central Square (Dark)") --Changes Radiant Garden: Entryway's Room Name
                    WriteByte(RoomNameText[game_version]+0x432,0x00) --Makes sure Room Name text doesn't overlap
                end
                if ReadByte(Save[game_version]+0x25D4) == 0x00 then --Never entered Radiant Garden
                    WriteString(RoomNameText[game_version]+0x478,"Central Square (Day)") --Changes Radiant Garden: Front Doors's Room Name
                    WriteByte(RoomNameText[game_version]+0x48C,0x00) --Makes sure Room Name text doesn't overlap
                    WriteInt(Save[game_version]+0x29B8,0x00000000)
                end
                if ReadByte(Save[game_version]+0x25D4) ~= 0x00 and ReadByte(Save[game_version]+0x25D4) <= 0x07 then --Before Front Doors Unversed
                    WriteLong(Save[game_version]+0x29BC, 0x0C0A02000C0A0000)
                    if ReadShort(Now[game_version]+0) == 0x0111 then
                        WriteInt(Save[game_version]+0x29B8, 0x00000000)
                    else
                        WriteInt(Save[game_version]+0x29B8, 0x0C0A0000)
                    end
                elseif ReadByte(Save[game_version]+0x25D4) == 0x0F  then --Before Trinity Armor
                    WriteLong(Save[game_version]+0x29BC, 0x000000000C0A0000)
                    WriteLong(Save[game_version]+0x29C4, 0x000000000C0A0100)
                    if ReadShort(Now[game_version]+0) == 0x0111 then
                        WriteInt(Save[game_version]+0x29B8, 0x00000000)
                    else
                        WriteInt(Save[game_version]+0x29B8, 0x0C0A0100)
                    end
                elseif ReadByte(Save[game_version]+0x25D4) == 0x3F or ReadByte(Save[game_version]+0x25D4) == 0x7F then --After Trinity Armor/Before Vanitas I
                    WriteLong(Save[game_version]+0x29BC, 0)
                    WriteLong(Save[game_version]+0x29C4, 0x0C0A030000000000)
                    if ReadShort(Now[game_version]+0) == 0x0111 then
                        WriteInt(Save[game_version]+0x29B8, 0x00000000)
                    else
                        WriteInt(Save[game_version]+0x29B8, 0x0C0A0300)
                    end
                elseif ReadByte(Save[game_version]+0x25D4) == 0xFF then --World Cleared
                    WriteLong(Save[game_version]+0x29BC, 0)
                    WriteLong(Save[game_version]+0x29C4, 0)
                    if ReadShort(Now[game_version]+0) == 0x0111 then
                        WriteInt(Save[game_version]+0x29B8, 0x00000000)
                    else
                        WriteInt(Save[game_version]+0x29B8, 0x0C0A0400)
                    end
                end
                if ReadShort(Now[game_version]+0) == 0x080D then --Final Episode: The Keyblade Graveyard
                    WriteArray(Now[game_version]+0,{0x0D, 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
                end
            end
            --Final Episode Radiant Garden (if you never entered the world) 2
            if ReadShort(Now[game_version]+0) == 0x0A06 then
                if ReadByte(Save[game_version]+0x25D4) == 0x00 then
                    WriteInt(Now[game_version]+48,0x00000306)
                end
                if ReadShort(Now[game_version]+48) == 0x0306 then
                    WriteArray(Now[game_version]+0,{0x06, 0x03, 0x00, 0x00, 0x4A, 0x00, 0x4A, 0x00, 0x4A})
                end
            end
            --Final Terra-Xehanort
            if ReadShort(Now[game_version]+0) == 0x0206 then
                WriteArray(Now[game_version]+0,{0x06, 0x0D, 0x00, 0x00, 0x4E, 0x00, 0x4E, 0x00, 0x4E})
            end
            --Start of Realm of Darkness 1
            if ReadShort(Now[game_version]+0) == 0x010A and ReadShort(Save[game_version]+0x25F5) == 0x0000 then
                WriteArray(Now[game_version]+0,{0x07, 0x14, 0x00, 0x00, 0x4D, 0x00, 0x4D, 0x00, 0x4D})
                WriteByte(Save[game_version]+0x295D,0x01)
            end
            --Start of Realm of Darkness 2
            if ReadShort(Now[game_version]+0) == 0x1407 and ReadShort(Now[game_version]+8) == 0x51 then
                if ReadByte(Save[game_version]+0x25F7) == 0 then
                    WriteByte(Save[game_version]+0x25F7,1)
                    WriteByte(Save[game_version]+0x2810,ReadByte(Save[game_version]+0x2810)+1)
                end
            end
            --Entering Realm of Darkness 1
            if ReadShort(Now[game_version]+48) == 0xFF0A and ReadShort(Save[game_version]+0x25F5) == 0x0001 then
                WriteInt(Now[game_version]+48,0x00631407)
                WriteArray(Now[game_version]+4,{0x00, 0x00, 0x01, 0x00, 0x00})
                WriteShort(Save[game_version]+0x14,0x1407)
            end
            --Entering Realm of Darkness 2
            if ReadShort(Now[game_version]+48) == 0xFF0A and ReadShort(Save[game_version]+0x25F5) > 0x0008 then
                WriteInt(Now[game_version]+48,0x00631607)
                WriteArray(Now[game_version]+4,{0x00, 0x00, 0x00, 0x00, 0x00})
                WriteShort(Save[game_version]+0x14,0x1607)
            end
            --Leaving Realm of Darkness
            if ReadShort(Now[game_version]+0) == 0x0111 then
                if ReadShort(Now[game_version]+0x10) == 0x1407 or ReadShort(Now[game_version]+0x10) == 0x1607 then
                    WriteShort(Now[game_version]+0x10,0111)
                    WriteByte(Now[game_version]+2,0x0A)
                    WriteByte(Save[game_version]+0x16,0x0A)
                end
            end
            --End of Realm of Darkness
            if ReadShort(Now[game_version]+0) == 0x1807 and ReadShort(Now[game_version]+0x10) == 0x1707 then
                if ReadByte(Save[game_version]+0x25FC) == 0 then
                    WriteByte(Save[game_version]+0x25DB,1)
                    WriteByte(Save[game_version]+0x2658,ReadByte(Save[game_version]+0x2658)+1)
                end
                WriteArray(Now[game_version]+0,{0x07, 0x16, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00})
                WriteShort(Save[game_version]+0x14,0x1607)
                WriteByte(Save[game_version]+0x25F5,0x0F)
                WriteByte(Save[game_version]+0x25FC,0x01)
                WriteShort(Save[game_version]+0x295D,0x0122)
                WriteArray(Save[game_version]+0xB58,{0x00, 0x00, 0x00, 0x00, 0x00})
                WriteByte(Save[game_version]+0xB62,0x01)
            end
            --Secret Episode Ending
            if ReadByte(Save[game_version]+0x25FC) == 1 then
                if ReadShort(Now[game_version]+0) == 0x040A and ReadShort(Now[game_version]+48) == 0xFF81 then
                    WriteShort(Now[game_version]+48,0x00001807)
                end
            end
            --Battle Report (if Secret Episode is finished) 1
            if ReadShort(Now[game_version]+0) == 0x1807 and ReadShort(Now[game_version]+0x10) == 0x040A then
                WriteArray(Now[game_version]+4,{0x52, 0x00, 0x52, 0x00, 0x52})
            end
            --Battle Report (if Secret Episode is finished) 2
            if ReadShort(Now[game_version]+0) == 0x1807 and ReadShort(Now[game_version]+48) == 0x1807 then
                WriteShort(Now[game_version]+48,0xFF81)
                WriteShort(Save[game_version]+0x14,0x1607)
            end
        end
    end
end
