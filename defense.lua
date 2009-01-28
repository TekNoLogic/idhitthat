
local L = tek_locale

local _, class = UnitClass("player")


tek_register("Interface\\Icons\\Ability_Warrior_DefensiveStance", function(self)
	local lesscrit, sotf, soh = 0

	if class == "DRUID" then
		sotf, _, _, _, lesscrit = GetTalentInfo(2, 18)
		lesscrit = lesscrit * 2
		if lesscrit == 0 then sotf = nil end
	elseif ( class == "ROGUE" ) then
		soh, _, _, _, lesscrit = GetTalentInfo(3, 4)
		if lesscrit == 0 then soh = nil end
	end

	local defskillmod = GetDodgeBlockParryChanceFromDefense() - 0.6

	local miss = math.max(5 + defskillmod, 0)
	local dodge = math.max(0, GetDodgeChance() - 0.6)
	local parry = math.max(0, GetParryChance() - 0.6)
	local block = math.max(0, GetBlockChance() - 0.6)
	local critical = math.max(5 - defskillmod - lesscrit - GetCombatRatingBonus(CR_CRIT_TAKEN_MELEE), 0)
	local hit = 0

	local mainhand = GetInventoryItemLink("player", 16)
	if not mainhand then parry = 0 else
		local _, _, _, _, _, _, _, _, mainhandtype = GetItemInfo(mainhand)
		if (mainhandtype ~= "INVTYPE_WEAPON") and (mainhandtype ~= "INVTYPE_WEAPONMAINHAND") and (mainhandtype ~= "INVTYPE_2HWEAPON") then parry = 0 end
	end

	local offhand = GetInventoryItemLink("player", 17)
	if not offhand then block = 0 else
		local _, _, _, _, _, _, _, _, offhandtype = GetItemInfo(offhand)
		if offhandtype ~= "INVTYPE_SHIELD" then block = 0 end
	end

	local leftover = 100

	miss = min(miss, leftover)
	leftover = leftover - miss

	dodge = min(dodge, leftover)
	leftover = leftover - dodge

	parry = min(parry, leftover)
	leftover = leftover - parry

	block = min(block, leftover)
	leftover = leftover - block

	critical = min(critical, leftover)
	leftover = leftover - critical

	hit = leftover


 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()

	GameTooltip:AddLine("Defense Table", 1,1,1)

	GameTooltip:AddDoubleLine(L["Miss"], string.format("%.2f%%", miss), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Dodge"], string.format("%.2f%%", dodge), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Parry"], string.format("%.2f%%", parry), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Block"], string.format("%.2f%%", block), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Critical"], string.format("%.2f%%", critical), nil,nil,nil, 1,0,0)
	GameTooltip:AddDoubleLine(L["Hit"], string.format("%.2f%%", hit), nil,nil,nil, 1,.5,0)

	if sotf or soh then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Hit Bonuses", 1,1,1)
		if sotf then GameTooltip:AddDoubleLine(sotf, "-"..lesscrit.."%", nil,nil,nil, 1,1,1) end
		if soh  then GameTooltip:AddDoubleLine(soh, "-"..lesscrit.."%", nil,nil,nil, 1,1,1) end
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("All values are vs. mobs\n3 levels above the player.", 0,1,0, true)

	GameTooltip:Show()
end)
