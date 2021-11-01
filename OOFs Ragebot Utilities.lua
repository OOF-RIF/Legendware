menu.add_key_bind("Force safe points")
menu.add_key_bind("Force body aim")

local function ForceSafePoint()
    for i = 0, 64 do
        if menu.get_key_bind_state("Force safe points") then
            menu.set_bool( "player_list.player_settings["..i.."].force_safe_points", true)
        else
            menu.set_bool( "player_list.player_settings["..i.."].force_safe_points", false)
        end
    end
end
local function ForceBodyAim()
    for i = 0, 64 do
        if menu.get_key_bind_state("Force body aim") then
            menu.set_bool( "player_list.player_settings["..i.."].force_body_aim", true)
        else
            menu.set_bool( "player_list.player_settings["..i.."].force_body_aim", false)
        end
    end
end

client.add_callback("create_move", function()
    if not engine.is_in_game() then return end
    
    ForceSafePoint()
    ForceBodyAim()
end)