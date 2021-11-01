-- Oh. My. God.
-- People think this
-- feature is worth money.
-- Embarassing...
---------------------------
-- We are setting up menu
menu.add_key_bind("OOF's Fake Flick")
-- Fake Flick function
local function FakeFlick()
	if not menu.get_key_bind_state("OOF's Fake Flick") then return end
	local inverter = menu.get_key_bind_state("anti_aim.invert_desync_key")
	local tickcount = globals.get_tickcount() % 19
	if tickcount == 14 or tickcount == 17 then
		if inverter == true then
			menu.set_int("anti_aim.yaw_offset", -90)
		else
			menu.set_int("anti_aim.yaw_offset", 90)
		end
	else
		menu.set_int("anti_aim.yaw_offset", 0)
	end
end
-- Callbacks
client.add_callback("on_paint", FakeFlick)