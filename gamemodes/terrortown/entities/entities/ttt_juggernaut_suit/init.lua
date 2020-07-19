-- author "Zaratusa"
-- contact "http://steamcommunity.com/profiles/76561198032479768"

-- co-author "FloTurtle"
-- contact "https://steamcommunity.com/profiles/76561198114511249"

-- player model cleanup "[T]obiti"
-- contact "https://steamcommunity.com/profiles/76561197989909602"

-- player model cleanup "V3kta"
-- contact "http://steamcommunity.com/profiles/76561198020955880"

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

resource.AddWorkshop("652046425") -- this addon

include('shared.lua')

local model = CreateConVar("ttt_juggernautsuit_model", "models/player/urban.mdl", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The player model for the Juggernaut Suit.")

local damage_factor_explosion = CreateConVar("ttt_juggernautsuit_damage_explosion", 0.20, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The explosion damage multiplier for the Juggernaut Suit.")
local maximum_damage_explosion = CreateConVar("ttt_juggernautsuit_maxdamage_explosion", 50, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum explosion damage inflicting the Juggernaut Suit.")

local damage_factor_fire = CreateConVar("ttt_juggernautsuit_damage_fire", 0.35, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The fire damage multiplier for the Juggernaut Suit.")
local maximum_damage_fire = CreateConVar("ttt_juggernautsuit_maxdamage_fire", 5, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The maximum fire damage inflicting the Juggernaut Suit.")

local damage_bullet = CreateConVar("ttt_juggernautsuit_damage_bullet", 0.80, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The bullet damage multiplier for the Juggernaut Suit.")
local damage_factor_shock = CreateConVar("ttt_juggernautsuit_damage_shock", 0.60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The shock damage multiplier for the Juggernaut Suit.")
local damage_factor_radiation = CreateConVar("ttt_juggernautsuit_damage_radiation", 0.60, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The radiation damage multiplier for the Juggernaut Suit.")
local damage_factor_crowbar = CreateConVar("ttt_juggernautsuit_damage_crowbar", 0.80, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The crowbar damage multiplier for the Juggernaut Suit.")
local damage_factor_slash = CreateConVar("ttt_juggernautsuit_damage_slash", 0.75, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The slash damage multiplier for the Juggernaut Suit.")
local damage_factor_fall = CreateConVar("ttt_juggernautsuit_damage_fall", 1.20, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The fall damage multiplier for the Juggernaut Suit.")
local damage_factor_drown = CreateConVar("ttt_juggernautsuit_damage_drown", 1.20, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "The drowning damage multiplier for the Juggernaut Suit.")

--[[Perk logic]]--
hook.Add("EntityTakeDamage", "TTTJuggernautSuit", function(ent, dmginfo)
	if (IsValid(ent) and ent:IsPlayer() and ent:Alive() and ent:IsTerror() and ent:HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
		if (dmginfo:IsDamageType(DMG_BULLET)) then
			dmginfo:ScaleDamage(damage_bullet:GetFloat())
		elseif (dmginfo:IsExplosionDamage()) then
			dmginfo:ScaleDamage(damage_factor_explosion.GetFloat())
			if (dmginfo:GetDamage() > maximum_damage_explosion:GetInt()) then
				dmginfo:SetDamage(maximum_damage_explosion:GetInt())
			end
		elseif (dmginfo:IsDamageType(DMG_BURN)) then
			dmginfo:ScaleDamage(damage_factor_fire.GetFloat())
			if (dmginfo:GetDamage() > maximum_damage_fire:GetInt()) then
				dmginfo:SetDamage(maximum_damage_fire:GetInt())
			end
		elseif (dmginfo:IsDamageType(DMG_SHOCK)) then
			dmginfo:ScaleDamage(damage_factor_shock.GetFloat())
		elseif (dmginfo:IsDamageType(DMG_RADIATION)) then
			dmginfo:ScaleDamage(damage_factor_radiation.GetFloat())
		elseif (dmginfo:IsDamageType(DMG_CLUB)) then
			dmginfo:ScaleDamage(damage_factor_crowbar:GetFloat())
		elseif (dmginfo:IsDamageType(DMG_SLASH)) then
			dmginfo:ScaleDamage(damage_factor_slash:GetFloat())
		elseif (dmginfo:IsFallDamage()) then
			dmginfo:ScaleDamage(damage_factor_fall:GetFloat());
		elseif (dmginfo:IsDamageType(DMG_DROWN)) then
			dmginfo:ScaleDamage(damage_factor_drown:GetFloat());
		end
	end
end)

hook.Add("TTTOrderedEquipment", "TTTJuggernautSuit", function(ply, equipment)
	if (equipment == EQUIP_JUGGERNAUT_SUIT) then
		ply:SetModel(model:GetString())
	end
end)

hook.Add("DoPlayerDeath", "TTTJuggernautSuit", function(ply)
	if (ply:HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
		local oldModel = GAMEMODE.playermodel or "models/player/phoenix.mdl"
		ply:SetModel(oldModel)
	end
end)

hook.Add("TTTEndRound", "TTTJuggernautSuit", function()
	for k, ply in pairs(player.GetAll()) do
		if (IsValid(ply) and ply:HasEquipmentItem(EQUIP_JUGGERNAUT_SUIT)) then
			local oldModel = GAMEMODE.playermodel or "models/player/phoenix.mdl"
			ply:SetModel(oldModel)
		end
	end
end)
