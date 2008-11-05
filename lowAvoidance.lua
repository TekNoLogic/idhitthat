local L = setmetatable({}, {__index=function(t,i) return i end})

local result = {
	miss     = 0,
	dodge    = 0,
	parry    = 0,
	block    = 0,
	critical = 0,
	hit      = 0,
}

local talentedcritreduct = 0

local f = CreateFrame("Button", nil, CharacterModelFrame)
f:SetFrameStrata("DIALOG")
f:SetPoint("BOTTOMRIGHT", -4, 25)
f:SetWidth(26) f:SetHeight(26)

local icon = f:CreateTexture(nil, "BACKGROUND")
icon:SetAllPoints()
icon:SetTexture("Interface\\Icons\\Ability_Warrior_DefensiveStance")

f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

local nounit = {COMBAT_RATING_UPDATE = true, CHARACTER_POINTS_CHANGED = true, PLAYER_LOGIN = true}
local function UpdateHitTable(self, event, unit)
	if not nounit[event] and unit ~= "player" then return end

	local defskillmod = GetDodgeBlockParryChanceFromDefense() - 0.6

	result.miss = math.max(5 + defskillmod, 0)
	result.dodge = math.max(0, GetDodgeChance() - 0.6)
	result.parry = math.max(0, GetParryChance() - 0.6)
	result.block = math.max(0, GetBlockChance() - 0.6)
	result.critical = math.max(5 - defskillmod - talentedcritreduct - GetCombatRatingBonus(CR_CRIT_TAKEN_MELEE), 0)
	result.hit = 0

	local mainhand = GetInventoryItemLink("player", 16)
	if not mainhand then result.parry = 0 else
		local _, _, _, _, _, _, _, _, mainhandtype = GetItemInfo(mainhand)
		if (mainhandtype ~= "INVTYPE_WEAPON") and (mainhandtype ~= "INVTYPE_WEAPONMAINHAND") and (mainhandtype ~= "INVTYPE_2HWEAPON") then
			result.parry = 0
		end
	end

	local offhand = GetInventoryItemLink("player", 17)
	if not offhand then result.block = 0 else
		local _, _, _, _, _, _, _, _, offhandtype = GetItemInfo(offhand)
		if offhandtype ~= "INVTYPE_SHIELD" then result.block = 0 end
	end

	local leftover = 100

	result.miss = min(result.miss, leftover)
	leftover = leftover - result.miss

	result.dodge = min(result.dodge, leftover)
	leftover = leftover - result.dodge

	result.parry = min(result.parry, leftover)
	leftover = leftover - result.parry

	result.block = min(result.block, leftover)
	leftover = leftover - result.block

	result.critical = min(result.critical, leftover)
	leftover = leftover - result.critical

	result.hit = leftover
end

function f:PLAYER_LOGIN()
	for _,e in pairs{"UNIT_DAMAGE","PLAYER_DAMAGE_DONE_MODS", "UNIT_ATTACK_SPEED", "UNIT_RANGEDDAMAGE", "UNIT_ATTACK", "UNIT_STATS", "UNIT_RANGED_ATTACK_POWER", "COMBAT_RATING_UPDATE"} do
		self:RegisterEvent(e)
		self[e] = UpdateHitTable
	end

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil

	local _, class = UnitClass("player")

	-- SoTF
	if ( class == "DRUID" ) then
		function self:CHARACTER_POINTS_CHANGED() talentedcritreduct = select(5, GetTalentInfo(2, 16)) end
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
		self:CHARACTER_POINTS_CHANGED()
	-- SoH
	elseif ( class == "ROGUE" ) then
		function self:CHARACTER_POINTS_CHANGED() talentedcritreduct = select(5, GetTalentInfo(3, 3)) end
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
		self:CHARACTER_POINTS_CHANGED()
	end

	UpdateHitTable(nil, "PLAYER_LOGIN")
end


f:SetScript("OnLeave", function() GameTooltip:Hide() end)
f:SetScript("OnEnter", function(self)
 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()

	GameTooltip:AddLine("Attack Table")

	GameTooltip:AddDoubleLine(L["Miss"], string.format("%.2f%%", result.miss), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Dodge"], string.format("%.2f%%", result.dodge), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Parry"], string.format("%.2f%%", result.parry), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Block"], string.format("%.2f%%", result.block), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Critical"], string.format("%.2f%%", result.critical), nil,nil,nil, 1,0,0)
	GameTooltip:AddDoubleLine(L["Hit"], string.format("%.2f%%", result.hit), nil,nil,nil, 1,.5,0)

	GameTooltip:Show()
end)


if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
