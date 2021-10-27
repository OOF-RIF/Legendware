-- Basic Semirage Script
menu.add_key_bind("Ragebot Key")
menu.add_key_bind("Autowall Key")
menu.add_key_bind("Autofire Key")
menu.add_key_bind("Override FOV")
menu.add_slider_int("Original FOV value", 1, 180)
menu.add_slider_int("Override FOV value", 1, 180)

local function HandleKeys()
    menu.set_bool("rage.enable", menu.get_key_bind_state("Ragebot Key"))

    menu.set_bool("rage.automatic_wall", menu.get_key_bind_state("Autowall Key"))

    menu.set_bool("rage.automatic_fire", menu.get_key_bind_state("Autofire Key"))

    if menu.get_key_bind_state("Override FOV") then
        menu.set_int("rage.field_of_view", menu.get_int("Override FOV value"))
    else 
        menu.set_int("rage.field_of_view", menu.get_int("Original FOV value"))
    end
end

client.add_callback("create_move", function () 
    HandleKeys()
end)