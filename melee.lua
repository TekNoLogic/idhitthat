
local L = tek_locale
local tip = LibStub("tektip-1.0").new(4, "LEFT", "RIGHT", "RIGHT", "RIGHT")

local _, class = UnitClass("player")

local function gettable(canglance, isdual, infront)
	local glance = canglance and 25 or 0
	local miss = math.max(9 + (isdual and 19 or 0) - GetCombatRatingBonus(CR_HIT_MELEE), 0)
	local parry = infront and math.max(9 - GetExpertisePercent(), 0) or 0
	local dodge = math.max(6.5 - GetExpertisePercent(), 0)
	local block = infront and 6.5 or 0
	local crit = GetCritChance()
	local hit = 0

	local leftover = 100

	miss = math.min(miss, leftover)
	leftover = leftover - miss

	dodge = math.min(dodge, leftover)
	leftover = leftover - dodge

	parry = math.min(parry, leftover)
	leftover = leftover - parry

	glance = math.min(glance, leftover)
	leftover = leftover - glance

	block = math.min(block, leftover)
	leftover = leftover - block

	crit = math.min(crit, leftover)
	leftover = leftover - crit

	hit = leftover

	return hit, crit, miss, dodge, glance, parry, block
end


tek_register("Interface\\Icons\\INV_Sword_26", function(self)
	local hit, crit, miss, dodge, glance = gettable(true)
	local dhit, dcrit, dmiss, ddodge, dglance = gettable(true, true)
	local shit, scrit, smiss, sdodge, sglance = gettable()


	tip:SetPoint("BOTTOMLEFT", self, "TOPRIGHT")

	tip:AddLine("Melee Tables", 1,1,1)
	tip:AddMultiLine("", "Normal", "Dual", "Special")

	tip:AddMultiLine(L["Critical"], string.format("%.2f%%", crit),   string.format("%.2f%%", dcrit),   string.format("%.2f%%", scrit),   nil,nil,nil, .5,1,.5, .5,1,.5, .5,1,.5)
	tip:AddMultiLine(L["Hit"],      string.format("%.2f%%", hit),    string.format("%.2f%%", dhit),    string.format("%.2f%%", shit),    nil,nil,nil, 1,1,1, 1,1,1, 1,1,1)
	tip:AddMultiLine(L["Miss"],     string.format("%.2f%%", miss),   string.format("%.2f%%", dmiss),   string.format("%.2f%%", smiss),   nil,nil,nil, 1,.5,0, 1,.5,0, 1,.5,0)
	tip:AddMultiLine(L["Dodge"],    string.format("%.2f%%", dodge),  string.format("%.2f%%", ddodge),  string.format("%.2f%%", sdodge),  nil,nil,nil, 1,.5,0, 1,.5,0, 1,.5,0)
	tip:AddMultiLine(L["Glancing"], string.format("%.2f%%", glance), string.format("%.2f%%", dglance), string.format("%.2f%%", sglance), nil,nil,nil, 1,.5,0, 1,.5,0, 1,.5,0)

	tip:AddLine(" ")
	tip:AddLine("All values are vs. mobs 3 levels above the player, attacking from behind, with capped weapon skill.", 0,1,0, true)

	tip:Show()
end, tip)
