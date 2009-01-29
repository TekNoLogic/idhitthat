
local L = tek_locale
local tip = LibStub("tektip-1.0").new(3, "LEFT", "RIGHT", "RIGHT", "RIGHT")

local _, class = UnitClass("player")

local function gettable(infront)
	local miss = math.max(8 - GetCombatRatingBonus(CR_HIT_RANGED), 0)
	local block = infront and 6.5 or 0
	local crit = GetCritChance()
	local hit = 0

	local leftover = 100

	miss = math.min(miss, leftover)
	leftover = leftover - miss

	block = math.min(block, leftover)
	leftover = leftover - block

	crit = math.min(crit, leftover)
	leftover = leftover - crit

	hit = leftover

	return hit, crit, miss, block
end


tek_register("Interface\\Icons\\INV_Misc_Ammo_Arrow_05", function(self)
	local hit, crit, miss, block = gettable()
	local fhit, fcrit, fmiss, fblock = gettable(true)


	tip:SetPoint("BOTTOMLEFT", self, "TOPRIGHT")

	tip:AddLine("Ranged Tables", 1,1,1)
	tip:AddMultiLine("", "Back", "Front")

	tip:AddMultiLine(L["Critical"], string.format("%.2f%%", crit),   string.format("%.2f%%", fcrit),   nil,nil,nil, .5,1,.5, .5,1,.5)
	tip:AddMultiLine(L["Hit"],      string.format("%.2f%%", hit),    string.format("%.2f%%", fhit),    nil,nil,nil, 1,1,1, 1,1,1)
	tip:AddMultiLine(L["Miss"],     string.format("%.2f%%", miss),   string.format("%.2f%%", fmiss),   nil,nil,nil, 1,.5,0, 1,.5,0)
	tip:AddMultiLine(L["Block"],    string.format("%.2f%%", block),  string.format("%.2f%%", fblock),  nil,nil,nil, 1,.5,0, 1,.5,0)

	tip:AddLine(" ")
	tip:AddLine("All values are vs. mobs 3 levels above the player, with capped weapon skill.", 0,1,0, true)

	tip:Show()
end, tip)
