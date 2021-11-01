local movestates = {
    "Standing",
    "Walking",
    "Running",
    "Crouching",
    "In Air",
}
for i = 1, #movestates do -- Create an antiaim option for every movestate
    menu.add_combo_box(movestates[i].." pitch", {"None", "Minimal", "Maximal"})
    menu.add_combo_box(movestates[i].." target yaw", {"Local view", "At targets"})
    menu.add_check_box(movestates[i].." edge yaw")
    menu.add_slider_int(movestates[i].." yaw offset", -180, 180)
    menu.add_combo_box(movestates[i].." yaw modifier", {"None", "Jitter", "Spin"})
    menu.add_slider_int(movestates[i].." range", 1, 180)
    menu.add_combo_box(movestates[i].." desync type", {"None", "Static", "Jitter"})
    menu.add_slider_int(movestates[i].." desync range", 1, 60)
    menu.add_slider_int(movestates[i].." desync range inverted", 1, 60)
    menu.add_combo_box(movestates[i].." fake lag type", {"Static", "Dynamic", "Fluctuate"})
    menu.add_slider_int(movestates[i].." fake lag limit", 1, 16)
    menu.next_line()
end
-- Get move states
-- Yes... It is this easy...
local function GetMoveState()
    -- cant be fucked to use get_velocity()
    local velocity_x = entitylist.get_local_player():get_prop_int("DT_CSPlayer", "m_vecVelocity[0]")
    local velocity_y = entitylist.get_local_player():get_prop_int("DT_CSPlayer", "m_vecVelocity[1]")
    local speed = velocity_x ~= nil and math.floor(math.sqrt(velocity_x * velocity_x + velocity_y * velocity_y + 0.5)) or 0
    -- using props to get movestates be like
    local InDuck = entitylist.get_local_player():get_prop_int("DT_CSPlayer", "m_fFlags") == 263
    local InAir = entitylist.get_local_player():get_prop_int("DT_CSPlayer", "m_fFlags") == 256
    -- now we actually get proper movestates...
    if not InDuck and not InAir and speed > 2 and speed <= 250 then
        return "Moving" -- We are standing when we are not: crouching, in air or slowwalking or running
    if speed <= 2 then
        return "Standing" -- We are crouching when we are not: in air, swlowalking, or running
    if InAir then
        return "In Air" -- We are crouching when we are not: in air, swlowalking, or running
    if menu.get_key_bind_state("misc.slow_walk_key") then
        return "Walking" -- We are crouching when we are not: in air, swlowalking, or running
    if InDuck then
        return "Crouching" -- We are in air
    end
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
    menu.set_int("anti_aim.fake_lag_type", menu.get_int(movestate.." fake lag type"))
    menu.set_int("anti_aim.fake_lag_limit", menu.get_int(movestate.." fake lag limit"))
end
-- Now we handle the actual antiaim portion.
local function HandleAntiAim()
    local movestate = GetMoveState() -- Get move state

    LoadAntiAim(movestate) -- Load antiaim settings
end

client.add_callback("create_move", function ()
    HandleAntiAim()
end)
