LUAGUI_NAME = "bbsAPConnector"
LUAGUI_AUTH = "Gicu"
LUAGUI_DESC = "BBS FM AP Connector"

game_version = 1 --1: EGS GL v1.0.0.10, 2: Steam GL v1.0.0.2, 3: Steam JP v1.0.0.2
IsEpicGLVersion = 0x68D229
IsSteamGLVersion = 0x68D451
IsSteamJPVersion = 0x68C401
can_execute = false
frame_count = 0

function define_world_progress_location_bits()
    world_progress_location_bits = {}
    world_progress_location_bits[0] = {} --Ventus
    world_progress_location_bits[1] = {} --Aqua
    world_progress_location_bits[2] = {} --Terra
    for k=0,2 do
        for i=1,14 do
            world_progress_location_bits[k][i] = {}
            for j=1,32 do
                world_progress_location_bits[k][i][j] = {}
            end
        end
    end
    --Ventus
    --The Land of Departure
    world_progress_location_bits[0][1][14]  = {2271020000, 2271020001} --Max HP Increase, Fever Pitch
    world_progress_location_bits[0][1][18]  = {2271020002, 2271020003, 2271020004, 2271020005} --Aqua D-Link, Terra D-Link, Xehanort's Letter, Keyblade Board
    world_progress_location_bits[0][1][27]  = {2271020006} --No Name
    --Dwarf Woodlands
    world_progress_location_bits[0][2][11]  = {2271020100} --Max HP Increase
    world_progress_location_bits[0][2][14]  = {2271020101, 2271020102} --Deck Capacity Increase, Firestorm
    world_progress_location_bits[0][2][15]  = {2271020103, 2271020104} --Snow White D-Link, Treasure Trove
    --Castle of Dreams
    world_progress_location_bits[0][3][9]   = {2271020200} --Diamond Dust
    world_progress_location_bits[0][3][11]  = {2271020201, 2271020202, 2271020203} --Cinderella D-Link, Stroke of Midnight, Royal Board
    --Enchanted Dominion
    world_progress_location_bits[0][4][13]  = {2271020300, 2271020301} --Max HP Increase, Thunderbolt
    world_progress_location_bits[0][4][15]  = {2271020302} --Fairy Stars
    --Mysterious Tower
    world_progress_location_bits[0][5][4]   = {2271020400, 2271020401} --Donald D-Link, Goofy D-Link
    --Radiant Garden
    world_progress_location_bits[0][6][3]   = {2271020500} --Disney Town Pass
    world_progress_location_bits[0][6][12]  = {2271020501} --Hunny Pot Board
    world_progress_location_bits[0][6][6]   = {2271020502, 2271020503} --Max HP Increase, Cyclone
    world_progress_location_bits[0][6][8]   = {2271020504} --Reversal
    world_progress_location_bits[0][6][11]  = {2271020505} --Frolic Flame
    --Olympus Coliseum
    world_progress_location_bits[0][8][7]   = {2271020700} --Max HP Increase
    world_progress_location_bits[0][8][10]  = {2271020701} --Deck Capacity Increase
    world_progress_location_bits[0][8][13]  = {2271020702, 2271020703, 2271020704} --Air Slide, Zack D-Link, Mark of a Hero
    --Deep Space
    world_progress_location_bits[0][9][4]   = {2271020800} --Wingblade
    world_progress_location_bits[0][9][11]  = {2271020801, 2271020802} --Max HP Increase, Deck Capacity Increase
    world_progress_location_bits[0][9][12]  = {2271020803, 2271020804, 2271020805} --Experiment 626 D-Link, Hyperdrive, Spaceship Board
    --Destiny Islands
    world_progress_location_bits[0][10][6]  = {2271020900, 2271020901} --Lost Memory, Xehanort's Report 9
    --Neverland
    world_progress_location_bits[0][11][11] = {2271021000} --Glide
    world_progress_location_bits[0][11][13] = {2271021001, 2271021002, 2271021003, 2271021004} --Deck Capacity Increase, Peter Pan D-Link, Pixie Petal, Skull Board
    --Disney Town
    world_progress_location_bits[0][12][6]  = {2271021100} --Toon Board
    --Keyblade Graveyard
    world_progress_location_bits[0][13][7]  = {2271021200, 2271021201} --Max HP Increase, Deck Capacity Increase
    world_progress_location_bits[0][7][2]   = {2271021202, 2271021203} --High Jump, Mickey D-Link
    world_progress_location_bits[0][13][17] = {2271021204} --Max HP Increase
    world_progress_location_bits[0][13][19] = {2271021205} --Final Vanitas
    world_progress_location_bits[0][13][24] = {2271021206} --Void Gear
    
    --Aqua
    --Land of Departure
    world_progress_location_bits[1][1][3]   = {2271120000, 2271120001} --Max HP Increase, Spellweaver
    world_progress_location_bits[1][1][5]   = {2271120002, 2271120003, 2271120004} --Ventus D-Link, Terra D-Link, Keyblade Board
    world_progress_location_bits[1][1][8]   = {2271120005} --Brightcrest
    world_progress_location_bits[1][1][12]  = {2271120006} --No Name
    --Dwarf Woodlands
    world_progress_location_bits[1][2][7]   = {2271120100} --Deck Capacity Increase
    world_progress_location_bits[1][2][10]  = {2271120101, 2271120102} --Snow White D-Link, Treasure Trove
    --Castle of Dreams
    world_progress_location_bits[1][3][4]   = {2271120200} --Map
    world_progress_location_bits[1][3][9]   = {2271120201} --Thunderbolt
    world_progress_location_bits[1][3][14]  = {2271120202, 2271120203} --Max HP Increase, Deck Capacity Increase
    world_progress_location_bits[1][3][15]  = {2271120204, 2271120205, 2271120206} --Cinderella D-Link, Stroke of Midnight, Royal Board
    --Enchanted Dominion
    world_progress_location_bits[1][4][8]   = {2271120300} --High Jump
    world_progress_location_bits[1][4][10]  = {2271120301, 2271120302} --Max HP Increase, Firestorm
    world_progress_location_bits[1][4][12]  = {2271120303, 2271120304} --Fairy Stars, Xehanort's Report 6
    --Mysterious Tower
    world_progress_location_bits[1][7][4]   = {2271120400, 2271120401, 2271120402} --Donald D-Link, Goofy D-Link, Xehanort's Report 4
    --Radiant Garden
    world_progress_location_bits[1][6][3]   = {2271120500, 2271120501} --Mickey D-Link, Destiny's Embrace
    world_progress_location_bits[1][6][6]   = {2271120502, 2271120503, 2271120504} --Max HP Increase, Bladecharge, Disney Town Pass
    world_progress_location_bits[1][6][10]  = {2271120505} --Hunny Pot Board
    world_progress_location_bits[1][6][9]   = {2271120506} --Deck Capacity Increase
    world_progress_location_bits[1][7][8]   = {2271120507} --Final Episode Story Complete
    --Realm of Darkness
    world_progress_location_bits[1][7][25]  = {2271120600} --Map
    world_progress_location_bits[1][7][11]  = {2271120601} --Secret Episode Story Complete
    --Olympus Coliseum
    world_progress_location_bits[1][8][6]   = {2271120700} --Max HP Increase
    world_progress_location_bits[1][8][10]  = {2271120701} --Deck Capacity Increase
    world_progress_location_bits[1][8][13]  = {2271120702} --Diamond Dust
    world_progress_location_bits[1][8][14]  = {2271120703, 2271120704} --Zack D-Link, Mark of a Hero
    --Deep Space
    world_progress_location_bits[1][9][10]  = {2271120800} --Air Slide
    world_progress_location_bits[1][9][7]   = {2271120801} --Max HP Increase
    world_progress_location_bits[1][9][11]  = {2271120800, 2271120801} --Air Slide or Max HP Increase
    world_progress_location_bits[1][9][14]  = {2271120802} --Deck Capacity Increase
    world_progress_location_bits[1][9][15]  = {2271120803, 2271120804, 2271120805} --Experiment 626 D-Link, Hyperdrive, Spaceship Board
    --Destiny Islands
    world_progress_location_bits[1][10][2]  = {2271120900} --Stormfall
    --Neverland
    world_progress_location_bits[1][11][6]  = {2271121000} --Doubleflight
    world_progress_location_bits[1][11][8]  = {2271121001, 2271121002} --Max HP Increase, Ghost Drive
    world_progress_location_bits[1][11][9]  = {2271121003, 2271121004, 2271121005} --Peter Pan D-Link, Pixie Petal, Skull Board
    --Disney Town
    world_progress_location_bits[1][12][2]  = {2271121100} --Balloon Letter
    world_progress_location_bits[1][12][5]  = {2271121101} --Toon Board
    --Keyblade Graveyard
    world_progress_location_bits[1][13][8]  = {2271121200} --Max HP Increase
    world_progress_location_bits[1][13][9]  = {2271121201} --Xehanort's Report 7
    world_progress_location_bits[1][13][13] = {2271121202} --Void Gear
    
    --Terra
    --Land of Departure
    world_progress_location_bits[2][1][11]  = {2271220000, 2271220001} --Max HP Increase, Critical Impact
    world_progress_location_bits[2][1][6]   = {2271220002, 2271220003, 2271220004} --Ventus D-Link, Aqua D-Link, Keyblade Board
    world_progress_location_bits[2][1][8]   = {2271220005} --Max HP Increase
    world_progress_location_bits[2][1][9]   =  {2271220006, 2271220007} --Chaos Ripper, Xehanort's Report 8
    world_progress_location_bits[2][1][15]  =  {2271220008} --No Name
    --Dwarf Woodlands
    world_progress_location_bits[2][2][5]   = {2271220100} --Air Slide
    world_progress_location_bits[2][2][8]   = {2271220101, 2271220102} --Max HP Increase, Firestorm
    world_progress_location_bits[2][2][12]  = {2271220103} --Treasure Trove
    --Castle of Dreams
    world_progress_location_bits[2][3][10]  = {2271220200} --Counter Hammer
    world_progress_location_bits[2][3][8]   = {2271220201, 2271220202} --Max HP Increase, Deck Capacity Increase
    world_progress_location_bits[2][3][13]  = {2271220203, 2271220204, 2271220205} --Cinderella D-Link, Stroke of Midnight, Royal Board
    --Enchanted Dominion
    world_progress_location_bits[2][4][7]   = {2271220300} --Maleficent D-Link
    world_progress_location_bits[2][4][8]   = {2271220301, 2271220302} --Deck Capacity Increase, Diamond Dust
    world_progress_location_bits[2][4][9]   = {2271220303} --Fairy Stars
    --Radiant Garden
    world_progress_location_bits[2][6][1]   = {2271220500} --Hunny Pot Board
    world_progress_location_bits[2][6][9]   = {2271220501, 2271220502, 2271220503} --Max HP Increase, Rockbreaker, Disney Town Pass
    world_progress_location_bits[2][6][12]  = {2271220504, 2271220505, 2271220506} --Deck Capacity Increase, Dark Volley, Xehanort's Report 2
    --Olympus Coliseum
    world_progress_location_bits[2][8][8]   = {2271220700, 2271220701} --Max HP Increase, Sonic Impact
    world_progress_location_bits[2][8][12]  = {2271220702, 2271220703, 2271220704} --Deck Capacity Increase, Zack D-Link, Mark of a Hero
    --Deep Space
    world_progress_location_bits[2][9][9]   = {2271220800} --Max HP Increase
    world_progress_location_bits[2][9][10]  = {2271220801} --Thunderbolt
    world_progress_location_bits[2][9][8]   = {2271220802, 2271220803, 2271220804} --Experiment 626 D-Link, Hyperdrive, Spaceship Board
    --Destiny Islands
    world_progress_location_bits[2][10][1]  = {2271220900} --Ends of the Earth
    --Neverland
    world_progress_location_bits[2][11][6]  = {2271221000, 2271221001} --Bladecharge, Peter Pan D-Link
    world_progress_location_bits[2][11][9]  = {2271221002} --Deck Capacity Increase
    world_progress_location_bits[2][11][10] = {2271221003, 2271221004} --Pixie Petal, Skull Board
    --Disney Town
    world_progress_location_bits[2][12][5]  = {2271221100} --Hi-Potion
    world_progress_location_bits[2][12][7]  = {2271221101} --Toon Board
    --Keyblade Graveyard
    world_progress_location_bits[2][13][3]  = {2271221200} --Dark Impulse
    world_progress_location_bits[2][13][10] = {2271221201} --Max HP Increase
    world_progress_location_bits[2][13][15] = {2271221202} --Story Complete
    world_progress_location_bits[2][13][18] = {2271221203} --Void Gear
    
    return world_progress_location_bits
end

world_progress_location_bits = define_world_progress_location_bits()

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

function version_choice(array, choice)
    a = array
    return a[choice]
end

function write_key_item(item_value)
    --Writes key item to the player's inventory
    key_item_stock_address = {0x10FA422C, 0x10FA3B2C}
    max_items = 40
    item_index = 0
    duplicate = false
    while ReadShort(key_item_stock_address[game_version] - (2 * item_index)) ~= 0 and item_index < max_items and not duplicate do
        if ReadShort(key_item_stock_address[game_version] - (2 * item_index)) == item_value then
            duplicate = true
        end
        item_index = item_index + 1
    end
    if item_index < max_items and not duplicate then
        WriteShort(key_item_stock_address[game_version] - (2 * item_index), item_value)
    end
end

function write_command(command_value)
    --Writes command to the player's inventory
    command_stock_address = {0X10FA4408, 0x10FA3D08}
    max_commands = 500
    command_value = command_value + 0x5B
    if command_value >= 0xBC and command_value <= 0xD2 then --Item Command
        command_index = 0
        while ReadShort(command_stock_address[game_version] + (10 * command_index)) ~= command_value and command_index < max_commands do
            command_index = command_index + 1
        end
        if command_index < max_commands then
            num_available = ReadShort(command_stock_address[game_version] + (10 * command_index) + 2)
            WriteShort(command_stock_address[game_version] + (10 * command_index) + 2, math.min(num_available + 1, 99))
            return
        end
    end
    command_index = 0
    while ReadShort(command_stock_address[game_version] + (10 * command_index)) ~= 0 and command_index < max_commands do
        command_index = command_index + 1
    end
    if command_index < max_commands then
        WriteShort(command_stock_address[game_version] + (10 * command_index) + 0, command_value) --Write Command
        WriteShort(command_stock_address[game_version] + (10 * command_index) + 2, 1) --Write Level
        WriteShort(command_stock_address[game_version] + (10 * command_index) + 4, 0) --Write Experience
        WriteShort(command_stock_address[game_version] + (10 * command_index) + 6, 0) --Write Ability
        WriteShort(command_stock_address[game_version] + (10 * command_index) + 8, 0) --Write Flags
    end
end

function write_dlink(dlink_value)
    --Writes d-link to the player's inventory
    dlink_offset = {}
    dlink_offset[0]  = 0x0
    dlink_offset[1]  = 0x8
    dlink_offset[2]  = 0x10
    dlink_offset[3]  = 0x38
    dlink_offset[4]  = 0x40
    dlink_offset[5]  = 0x28
    dlink_offset[6]  = 0x20
    dlink_offset[7]  = 0x18
    dlink_offset[8]  = 0x30
    dlink_offset[9]  = 0x48
    dlink_offset[10] = -0x10
    dlink_offset[11] = -0x18
    dlink_offset[12] = -0x8
    dlinks_address = {0x10FA664C, 0x10FA5F4C}
    duplicate = false
    if not duplicate then
        WriteShort(dlinks_address[game_version] + dlink_offset[dlink_value] + 0, dlink_value + 0x163) --Write D-Link
        WriteShort(dlinks_address[game_version] + dlink_offset[dlink_value] + 2, 0x8000) --Write ??
        WriteShort(dlinks_address[game_version] + dlink_offset[dlink_value] + 4, 0) --Write ??
        WriteShort(dlinks_address[game_version] + dlink_offset[dlink_value] + 6, 0) --Write ??
    end
end

function write_ability(ability_offset)
    --Write ability to the player's ability array
    abilities_address = {0x10FA5CD4, 0x10FA55D4}
    ability_byte_1 = ReadByte(abilities_address[game_version] + (ability_offset) * 4)
    ability_byte_2 = ReadByte((abilities_address[game_version] + (ability_offset) * 4)+1)
    ability_bits_1 = toBits(ability_byte_1, 8)
    ability_bits_2 = toBits(ability_byte_2, 8)
    number_permanantly_available = toNum({ability_bits_1[7], ability_bits_1[8], ability_bits_2[1]})
    if number_permanantly_available < 7 then
        number_permanantly_available = number_permanantly_available + 1
    end
    number_permanantly_available_bits = toBits(number_permanantly_available, 3)
    ability_bits_1[7] = number_permanantly_available_bits[1]
    ability_bits_1[8] = number_permanantly_available_bits[2]
    ability_bits_2[1] = number_permanantly_available_bits[3]
    ability_bits_2[7] = 1
    ability_byte_1 = toNum(ability_bits_1)
    ability_byte_2 = toNum(ability_bits_2)
    WriteByte(abilities_address[game_version] + (ability_offset) * 4, ability_byte_1)
    WriteByte((abilities_address[game_version] + (ability_offset) * 4)+1, ability_byte_2)
end

function write_command_style(command_style_offset)
    --Writes command style to a players command style array
    command_style_address = {0x10FA5D4C, 0x10FA564C}
    WriteByte(command_style_address[game_version]+command_style_offset, 0x05)
end

function write_worlds()
    world_open_address = {0x10FA0F70 + 0x2938, 0x10FA0870 + 0x2938}
    world_open_values = {
        0x00002002, --LOD
        0x00000102, --DW
        0x00000102, --COD
        0x00000102, --ED
        0x00000102, --MT
        0x00000102, --RG
        0x00000000, --Unused
        0x00000102, --OC
        0x00000102, --DS
        0x00000802, --DI
        0x00000102, --NL
        0x00000102, --DT
        0x00000102  --KG
        }
    for world_offset, world_value in pairs(worlds_unlocked_array) do
        if world_value == 0 then
            WriteInt(world_open_address[game_version] + (4 * (world_offset-1)), 0)
        elseif ReadInt(world_open_address[game_version] + (4 * (world_offset-1))) ~= world_open_values[world_offset] then
            WriteInt(world_open_address[game_version] + (4 * (world_offset-1)), world_open_values[world_offset])
        end
    end
end

function write_check_number(value)
    check_number_address = {0x10FA34A0, 0x10FA2DA0}
    WriteInt(check_number_address[game_version], value)
end

function write_max_hp(value)
    max_hp_pointer_address = {0x10FB5978, 0x10FB5278}
    if ReadInt(max_hp_pointer_address[game_version]) ~= 0 then
        max_hp_address = GetPointer(max_hp_pointer_address[game_version], 0x2548)
        return WriteShort(max_hp_address, value, true)
    else
        max_hp_pointer_address = {0x10F9F540, 0x10F9EE40}
        max_hp_pointer_offset_1 = 0x118
        max_hp_pointer_offset_2 = 0x398
        max_hp_pointer_offset_3 = 0xA4
        max_hp_pointer = GetPointer(max_hp_pointer_address[game_version], max_hp_pointer_offset_1)
        max_hp_pointer = GetPointer(max_hp_pointer, max_hp_pointer_offset_2, true)
        max_hp_pointer = GetPointer(max_hp_pointer, max_hp_pointer_offset_3, true)
        return WriteShort(max_hp_pointer, value, true)
    end
end

function write_deck_capacity(value)
    deck_capacity_pointer_address = {0x10FB5978, 0x10FB5278}
    if ReadInt(deck_capacity_pointer_address[game_version]) ~= 0 then --in menu
        deck_capacity_address = GetPointer(deck_capacity_pointer_address[game_version], 0x27F2)
        WriteByte(deck_capacity_address, math.min(value, 8), true)
    else
        deck_capacity_address = {0x10F9F5E6, 0x10F9EEE6}
        WriteByte(deck_capacity_address[game_version], math.min(value, 8))
    end
end

function write_world_item(world_offset)
    if world_offset <= 12 then
        ap_bits_address = {0x10FA349C, 0x10FA2D9C}
        address_offset = math.floor(world_offset / 8)
        bit_num = (world_offset % 8) + 1
        ap_byte = ReadByte(ap_bits_address[game_version] + address_offset)
        ap_bits = toBits(ap_byte, 8)
        ap_bits[bit_num] = 1
        WriteByte(ap_bits_address[game_version] + address_offset, toNum(ap_bits))
    end
end

function write_victory_item()
    ap_bits_address = {0x10FA349D, 0x10FA2D9D}
    ap_byte = ReadByte(ap_bits_address[game_version])
    ap_bits = toBits(ap_byte, 8)
    ap_bits[6] = 1
    WriteByte(ap_bits_address[game_version], toNum(ap_bits))
end

function write_ap_item_text()
    dummy_id_text_address = {0xD66CD0, 0xD665D0}
    disney_town_pass_text_address = dummy_id_text_address[game_version] + 0x910
    disney_town_pass_description_address = dummy_id_text_address[game_version] + 0x3B6C
    WriteArray(dummy_id_text_address[game_version],  {0x41,0x50,0x20,0x49,0x74,0x65,0x6D,0x00})
    WriteArray(disney_town_pass_text_address,        {0x41,0x72,0x63,0x68,0x69,0x70,0x65,0x6C,0x61,0x67,0x6F,0x20,0x49,0x74,0x65,0x6D})
    WriteArray(disney_town_pass_description_address, {0x41,0x6E,0x20,0x69,0x74,0x65,0x6D,0x20,0x66,0x6F,0x72,0x20,0x79,0x6F,0x75,0x20,0x6F,0x72,0x20,0x61,0x6E,0x6F,0x74,0x68,0x65,0x72,0x20,0x70,0x6C,0x61,0x79,0x65,0x72,0x00,0x2E})
end

function write_command_board(item_value)
    command_board_address = {0x10FABE98, 0x10FAB798}
    current_command_board_byte = ReadByte(command_board_address[game_version])
    current_command_board_bits = toBits(current_command_board_byte, 8)
    current_command_board_bits[item_value + 1] = 1
    WriteByte(command_board_address[game_version], toNum(current_command_board_bits))
end

function read_check_number()
    check_number_address = {0x10FA34A0, 0x10FA2DA0}
    return ReadInt(check_number_address[game_version])
end

function read_max_hp()
    max_hp_pointer_address = {0x10FB5978, 0x10FB5278}
    if ReadInt(max_hp_pointer_address[game_version]) ~= 0 then
        max_hp_address = GetPointer(max_hp_pointer_address[game_version], 0x2548)
        return ReadShort(max_hp_address, true)
    else
        max_hp_pointer_address = {0x10F9F540, 0x10F9EE40}
        max_hp_pointer_offset_1 = 0x118
        max_hp_pointer_offset_2 = 0x398
        max_hp_pointer_offset_3 = 0xA4
        max_hp_pointer = GetPointer(max_hp_pointer_address[game_version], max_hp_pointer_offset_1)
        max_hp_pointer = GetPointer(max_hp_pointer, max_hp_pointer_offset_2, true)
        max_hp_pointer = GetPointer(max_hp_pointer, max_hp_pointer_offset_3, true)
        return ReadShort(max_hp_pointer, true)
    end
end

function read_deck_capacity()
    deck_capacity_pointer_address = {0x10FB5978, 0x10FB5278}
    if ReadInt(deck_capacity_pointer_address[game_version]) ~= 0 then --in menu
        deck_capacity_address = GetPointer(deck_capacity_pointer_address[game_version], 0x27F2)
        return ReadByte(deck_capacity_address, true)
    else
        deck_capacity_address = {0x10F9F5E6, 0x10F9EEE6}
        return ReadByte(deck_capacity_address[game_version])
    end
end

function read_chest_location_ids()
    location_ids = {}
    chests_opened_address = {0x10FA42FC, 0x10FA3BFC}
    location_add_array = {2271000000, 2271100000, 2271200000}
    chests_opened_array = ReadArray(chests_opened_address[game_version], 27)
    for chest_index, chest_byte in pairs(chests_opened_array) do
        chest_bits = toBits(chest_byte, 8)
        for i=1,8 do
            if chest_bits[i] == 1 then
                location_ids[#location_ids + 1] = location_add_array[read_current_character() + 1] + ((chest_index-1)*10) + i
            end
        end
    end
    return location_ids
end

function read_sticker_location_ids()
    location_ids = {}
    stickers_found_address = {0x10FA431C, 0x10FA3C1C}
    location_add_array = {2271010000, 2271110000, 2271210000}
    stickers_opened_array = ReadArray(stickers_found_address[game_version], 3)
    for sticker_index, sticker_byte in pairs(stickers_opened_array) do
        sticker_bits = toBits(sticker_byte, 8)
        for i=1,8 do
            if sticker_bits[i] == 1 then
                location_ids[#location_ids + 1] = location_add_array[read_current_character() + 1] + ((sticker_index-1)*10) + i
            end
        end
    end
    return location_ids
end

function read_world_progress_location_ids()
    world_progress_address = {0x10FA34A4, 0x10FA2DA4}
    location_ids = {}
    world_progress_index = 0
    while world_progress_index < 14 do
        world_progress_value = ReadInt(world_progress_address[game_version] + (0x20 * world_progress_index))
        world_progress_bits = toBits(world_progress_value, 32)
        for i=1,32 do
            if world_progress_bits[i] > 0 then
                for k,v in pairs(world_progress_location_bits[read_current_character()][world_progress_index+1][i]) do
                    location_ids[#location_ids + 1] = v
                end
            end
        end
        world_progress_index = world_progress_index + 1
    end
    return location_ids
end

function read_misc_location_ids()
    --[[Reads other checks that aren't associated with Chests, Stickers, or Story Progression.]]
    location_ids = {}
    lookup_table = {
        --Ventus
        {
            {{0x10FB0DFC, 0x10FB06FC}, 2271030000, 1, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271030001, 2, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271030002, 3, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271030003, 4, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271030004, 5, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271030005, 6, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271030006, 7, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271030007, 8, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030008, 1, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030009, 2, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030010, 3, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030011, 3, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030012, 4, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030013, 4, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030014, 5, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030015, 6, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030016, 7, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030017, 8, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271030018, 8, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030019, 1, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030020, 2, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030021, 2, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030022, 3, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030023, 4, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030024, 5, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030025, 6, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030026, 7, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030027, 7, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030028, 8, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271030029, 8, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271030030, 1, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271030031, 1, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271030032, 2, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271030033, 3, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271030034, 4, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271030035, 5, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271030036, 6, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271030037, 6, 0x0}
        },
        --Aqua
        {
            {{0x10FB0DFC, 0x10FB06FC}, 2271130000, 1, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271130001, 2, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271130002, 3, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271130003, 4, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271130004, 5, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271130005, 6, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271130006, 7, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271130007, 8, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271130008, 8, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130009, 1, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130010, 2, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130011, 3, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130012, 4, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130013, 5, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130014, 5, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130015, 6, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130016, 7, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130017, 8, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271130018, 8, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130019, 1, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130020, 2, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130021, 2, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130022, 3, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130023, 4, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130024, 5, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130025, 6, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130026, 7, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130027, 7, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130028, 8, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271130029, 8, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271130030, 1, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271130031, 1, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271130032, 2, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271130033, 3, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271130034, 4, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271130035, 5, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271130036, 6, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271130037, 6, 0x0}
        },
        --Terra
        {
            {{0x10FB0DFC, 0x10FB06FC}, 2271230000, 1, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271230001, 2, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271230002, 3, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271230003, 4, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271230004, 5, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271230005, 6, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271230006, 7, 0x0},
            {{0x10FB0DFC, 0x10FB06FC}, 2271230007, 8, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230008, 1, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230009, 2, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230010, 2, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230011, 3, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230012, 3, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230013, 4, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230014, 4, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230015, 5, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230016, 6, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230017, 7, 0x0},
            {{0x10FB0DFD, 0x10FB06FD}, 2271230018, 8, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230019, 1, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230020, 1, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230021, 2, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230022, 2, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230023, 3, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230024, 4, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230025, 5, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230026, 6, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230027, 7, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230028, 7, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230029, 8, 0x0},
            {{0x10FB0DFE, 0x10FB06FE}, 2271230030, 8, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271230031, 1, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271230032, 1, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271230033, 2, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271230034, 3, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271230035, 4, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271230036, 5, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271230037, 6, 0x0},
            {{0x10FB0DFF, 0x10FB06FF}, 2271230038, 6, 0x0}
        }
    }
    for k,v in pairs(lookup_table[read_current_character() + 1]) do
        value = ReadByte(v[1][game_version])
        if v[3] == 0 and value >= v[4] then
            table.insert(location_ids, v[2])
        elseif v[3] > 0 and (value%(2^v[3]) >= 2^(v[3]-1)) then
            table.insert(location_ids, v[2])
        end
    end
    return location_ids
end

function read_current_character()
    current_character_address = {0x10FA0F80, 0x10FA0880}
    return ReadByte(current_character_address[game_version])
end

function victorious()
    ap_bits_address = {0x10FA349D, 0x10FA2D9D}
    ap_byte = ReadByte(ap_bits_address[game_version])
    ap_bits = toBits(ap_byte, 8)
    if ap_bits[6] == 1 then
        return true
    else
        return false
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

function receive_items()
    i = read_check_number() + 1
    while file_exists(client_communication_path .. "AP_" .. tostring(i) .. ".item") do
        file = io.open(client_communication_path .. "AP_" .. tostring(i) .. ".item", "r")
        io.input(file)
        received_item_id = tonumber(io.read())
        io.close(file)
        if received_item_id == 2270000000 then
            write_victory_item()
        elseif received_item_id >= 2270010000 and received_item_id <= 2270010210 then
            item_value = received_item_id % 2270010000
            write_command(item_value)
        elseif received_item_id >= 2270020000 and received_item_id <= 2270020014 then
            item_value = received_item_id % 2270020000
            write_command_style(item_value)
        elseif received_item_id >= 2270030000 and received_item_id <= 2270030029 then
            item_value = received_item_id % 2270030000
            write_ability(item_value)
        elseif received_item_id >= 2270040001 and received_item_id <= 2270047968 then
            item_value = received_item_id % 2270040000
            write_key_item(item_value)
        elseif received_item_id >= 2270050000 and received_item_id <= 2270050013 then
            item_value = received_item_id % 2270050000
            write_world_item(item_value)
        elseif received_item_id == 2270060000 then
            write_max_hp(read_max_hp() + 10)
        elseif received_item_id == 2270060001 then
            write_deck_capacity(read_deck_capacity() + 1)
        elseif received_item_id >= 2270070000 and received_item_id <= 2270070012 then
            item_value = received_item_id % 2270070000
            write_dlink(item_value)
        elseif received_item_id >= 2270080000 and received_item_id <= 2270080006 then
            item_value = received_item_id % 2270080000
            write_command_board(item_value)
        end
        i = i + 1
    end
    write_check_number(i-1)
end

function send_items()
    chest_location_ids = read_chest_location_ids()
    for location_index, location_id in pairs(chest_location_ids) do
        if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
            file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
    sticker_location_ids = read_sticker_location_ids()
    for location_index, location_id in pairs(sticker_location_ids) do
        if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
            file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
    world_progress_location_ids = read_world_progress_location_ids()
    for location_index, location_id in pairs(world_progress_location_ids) do
        if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
            file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
    misc_location_ids = read_misc_location_ids()
    for location_index, location_id in pairs(misc_location_ids) do
        if not file_exists(client_communication_path .. "send" .. tostring(location_id)) then
            file = io.open(client_communication_path .. "send" .. tostring(location_id), "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
    if victorious() then
        if not file_exists(client_communication_path .. "victory") then
            file = io.open(client_communication_path .. "victory", "w")
            io.output(file)
            io.write("")
            io.close(file)
        end
    end
end

function remove_starting_wayfinder()
    starting_wayfinder_address = {0x10FA41CC, 0x10FA3ACC}
    item = ReadInt(starting_wayfinder_address[game_version])
    if item == 0x1F1C or item == 0x1F1F or item == 0x1F20 then
        WriteInt(starting_wayfinder_address[game_version], 0x0)
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
    if frame_count == 0 then
        if character_selected_or_save_loaded() then
            remove_starting_wayfinder()
            write_ap_item_text()
            receive_items()
            send_items()
        end
    end
end
