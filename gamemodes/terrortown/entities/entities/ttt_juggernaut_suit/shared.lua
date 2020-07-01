-- author "Zaratusa"
-- contact "http://steamcommunity.com/profiles/76561198032479768"

CreateConVar("ttt_juggernautsuit_detective", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should Detectives be able to buy the Juggernaut Suit?", 0, 1)
CreateConVar("ttt_juggernautsuit_traitor", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should Traitors be able to buy the Juggernaut Suit?", 0, 1)
local speed = CreateConVar("ttt_juggernautsuit_speed", 0.80, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "The speed multiplier for the Juggernaut Suit.")

EQUIP_JUGGERNAUT_SUIT = GenerateNewEquipmentID()

local perk = {
	id = EQUIP_JUGGERNAUT_SUIT,
	loadout = false,
	type = "item_passive",
	material = "vgui/ttt/icon_juggernaut_suit",
	name = "juggernaut_suit_name",
	desc = "juggernaut_suit_desc",
	hud = true
}

if (GetConVar("ttt_juggernautsuit_detective"):GetBool()) then
	if SERVER then
		perk["loadout"] = GetConVar("ttt_juggernautsuit_detective_loadout"):GetBool()
	end
	table.insert(EquipmentItems[ROLE_DETECTIVE], perk)
end
if (GetConVar("ttt_juggernautsuit_traitor"):GetBool()) then
	if SERVER then
		perk["loadout"] = GetConVar("ttt_juggernautsuit_traitor_loadout"):GetBool()
	end
	table.insert(EquipmentItems[ROLE_TRAITOR], perk)
end

--[[Perk logic]]--
hook.Add("TTTPlayerSpeedModifier", "TTTJuggernautSuit", function(ply)
	if (IsValid(ply) and ply:HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
		-- ply.mult is for compatibility with TTT Sprint (ID: 933056549)
		if (EQUIP_HERMES_BOOTS and ply:HasEquipmentItem(EQUIP_HERMES_BOOTS)) then
			return (ply.mult or 1) * speed:GetFloat() * GetConVar("ttt_hermesboots_speed"):GetFloat() -- multiply with the speed of the Hermes Boots
		else
			return (ply.mult or 1) * speed:GetFloat()
		end
	end
end)
