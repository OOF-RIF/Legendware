local names = {} -- Names of players on your team
local old_tick = globals.get_tickcount()

local function IsAlive(entity) 
    return entity:get_prop_int("DT_CSPlayerResource", "m_bAlive")
end
local function UpdateNames()
    local ret = {}
    local local_player = entitylist.get_local_player()
    for i = globals.get_maxclients(), 1, -1 do
        i = math.floor(i) 
        local name = i:get_prop_int("DT_CSPlayer", "m_iName")
        if name == "unknown" and i == local_player then return end
        local my_team = local_player:get_prop_int("DT_CSPlayer", "m_iTeamNum")
        local i_team = i:get_prop_int("DT_CSPlayer", "m_iTeamNum")
        table.insert(ret, name)
    end
    names = ret
    if engine.is_in_game() then menu.add_combo_box("Target Player", {"None", names}) end
end
menu.add_check_box("Kick Target Player")
menu.add_check_box("Radio Spam")
menu.next_line()
menu.add_key_bind("Verticle Blockbot")
menu.add_key_bind("Horizontal Blockbot")
local function GetPlayerFromName(name) -- Get a player from their name
    for player = 1, globals.get_maxclients() do 
        local tmp_name = player:get_prop_int("DT_CSPlayer", "m_iName")
        if tmp_name == name then return player end
    end
end
local function KickTarget() -- Kicks a player
    if not menu.get_bool("Kick Target Player") then return end
    if menu.get_bool("Kick Target Player") then menu.set_bool("Kick Target Player", false) end

    for i = 1, 20000 do
        if entitylist.get_entity_by_index(i) == GetPlayerFromName(names[menu.get_int("Target Player")]) then
            client.log(""..i) 
            console.execute("callvote kick "..i)
            break;
        end
    end
end
local function RadioSpammer()
    if not menu.get_bool("Radio Spam") or not IsAlive(entitylist.get_local_player()) then return end

    if globals.get_tickcount() - old_tick > 120 then
		console.execute("cmd report")
		old_tick = globals.get_tickcount()
	end
end
local function VeritcalBlockbot(cmd)
    if not menu.get_key_bind_state("Verticle Blockbot") or not IsAlive(entitylist.get_local_player()) then return end

    local my_x, my_y = entitylist:get_local_player():get_prop_int("DT_CSPlayer", "m_vecOrigin[0]"), entitylist:get_local_player():get_prop_int("DT_CSPlayer", "m_vecOrigin[1]")
    local blockedplayer = entitylist:get_local_player():get_prop_int("DT_CSPlayer", "m_hGroundEntity") 
    if blockedplayer == nil or IsAlive(blockedplayer) then return end
    local bp_x, bp_y = blockedplayer:get_prop_int("DT_CSPlayer", "m_vecOrigin[0]"), blockedplayer:get_prop_int("DT_CSPlayer", "m_vecOrigin[1]") 
    local dist_x, dist_y = my_x - bp_x, my_y - bp_y
    cmd.forwardmove = -dist_x * 500
    cmd.sidemove = dist_y * 500
end
local function HorizontalBlockbot(cmd) 
    if not menu.get_key_bind_state("Horizontal Blockbot") or not IsAlive(entitylist.get_local_player()) then return end

    local target = GetPlayerFromName(names[menu.get_int("Target Player")])
    if target == nil or not IsAlive(target) then return end
    local my_x, my_y = entitylist:get_local_player():get_prop_int("DT_CSPlayer", "m_vecOrigin[0]"), entitylist:get_local_player():get_prop_int("DT_CSPlayer", "m_vecOrigin[1]")
    local bp_x, bp_y = target:get_prop_int("DT_CSPlayer", "m_vecOrigin[0]"), target:get_prop_int("DT_CSPlayer", "m_vecOrigin[1]")
    local dist_x, dist_y = my_x - bp_x, my_y - bp_y
    local yaw = entitylist:get_local_player():get_prop_int("DT_CSPlayer", "m_angEyeAngles[1]")
    if yaw >= 0 and yaw <= 90 then
        cmd.sidemove = dist_y * 500
    end
    if yaw >= 90 then
        cmd.sidemove = -dist_x * 500
    end
    if yaw <= 0 and yaw >= -90 then 
        cmd.sidemove = dist_x * 500
    end
    if yaw <= -90 then
        cmd.sidemove = -dist_y * 500
    end
end


client.add_callback("on_paint", function ()
    KickTarget()
    RadioSpammer()
    VeritcalBlockbot()
    HorizontalBlockbot()
end)
events.register_event("player_connect_full", function ()
    UpdateNames()
    old_tick = globals.get_tickcount()
    return
end)