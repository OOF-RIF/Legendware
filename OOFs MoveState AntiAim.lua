-- store movestates
local movestates = {
    "Standing",
    "Walking",
    "Running",
    "Crouching",
    "In Air",
}
-- create an antiaim option for every movestate
for i = 1, #movestates do
    menu.add_combo_box(movestates[i].." pitch", {"None", "Minimal", "Maximal"})
    menu.add_combo_box(movestates[i].." target yaw", {"Local view", "At targets"})
    menu.add_check_box(movestates[i].." edge yaw")
    menu.add_slider_int(movestates[i].." yaw offset", -180, 180)
    menu.add_combo_box(movestates[i].." yaw modifier", {"None", "Jitter", "Spin"})
    menu.add_slider_int(movestates[i].." range", 1, 180)
    menu.add_combo_box(movestates[i].." desync type", {"None", "Static", "Jitter"})
    menu.add_slider_int(movestates[i].." desync range", 1, 60)
    menu.add_slider_int(movestates[i].." desync range inverted", 1, 60)
    menu.next_line()
end
-- Load the appropriate antiaim settings
local function LoadAntiAim(movestate)
    menu.set_int("anti_aim.pitch", menu.get_int(movestate.." pitch"))
    menu.set_int("anti_aim.target_yaw", menu.get_int(movestate.." target yaw"))
    menu.set_bool("anti_aim.edge_yaw", menu.get_bool(movestate.." edge yaw"))
    menu.set_int("anti_aim.yaw_offset", menu.get_int(movestate.." yaw offset"))
    menu.set_int("anti_aim.yaw_modifier", menu.get_int(movestate.." yaw modifier"))
    menu.set_int("anti_aim.yaw_modifier_range", menu.get_int(movestate.." range"))
    menu.set_int("anti_aim.desync_type", menu.get_int(movestate.." desync type"))
    menu.set_int("anti_aim.desync_range", menu.get_int(movestate.." desync range"))
    menu.set_int("anti_aim.desync_range_inverted", menu.get_int(movestate.." desync range inverted"))
end
-- Handle anti-aim
local function HandleAntiAim()
    -- i had to use get_velocity... that was the entire issue...
	local speed = math.floor(entitylist.get_local_player():get_velocity():length_2d())
    -- using props to get movetypes
    local InDuck = entitylist.get_local_player():get_prop_int("CBasePlayer", "m_fFlags") == 263
    local InAir = entitylist.get_local_player():get_prop_int("CBasePlayer", "m_fFlags") == 256
    -- now we actually get proper movestates...
    if not InAir and not InDuck and speed > 1 then
		-- we are running
		LoadAntiAim("Running")
	elseif speed <= 1 then
		-- we are standing
		LoadAntiAim("Standing")
	end
	if InAir then
		-- we are in air
		LoadAntiAim("In Air")
	end
	if menu.get_key_bind_state("misc.slow_walk_key") then
		-- we are walking
		LoadAntiAim("Walking")
	end
	if InDuck then
		-- we are crouching
		LoadAntiAim("Crouching")
	end
end
-- Callback
client.add_callback("create_move", HandleAntiAim)
