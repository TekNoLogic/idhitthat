
local L = tek_locale
local tip = LibStub("tektip-1.0").new(4, "LEFT", "RIGHT", "RIGHT", "RIGHT")

local _, class = UnitClass("player")

local hasHP, nocs, nocsv, hotc, hotcv
local function gettable(canglance, isdual, infront)
	hasHP = UnitAura("player", "Heroic Presence")

	local glance = canglance and 25 or 0
	local miss = math.max(8 + (isdual and 19 or 0) - (hasHP and 1 or 0) - GetCombatRatingBonus(CR_HIT_MELEE), 0)
	local parry = infront and math.max(9 - GetExpertisePercent(), 0) or 0
	local dodge = math.max(6.5 - GetExpertisePercent(), 0)
	local block = infront and 6.5 or 0
	local crit = GetCritChance()
	local hit = 0

	if class == "DEATHKNIGHT" and not infront then
		nocs, _, _, _, nocsv = GetTalentInfo(2,6)
		if nocsv > 0 then miss = math.max(0, miss - nocsv) else nocsv = nil end
	end

	if class == "SHAMAN" and not infront then
		nocs, _, _, _, nocsv = GetTalentInfo(2,18)
		if nocsv > 0 then miss, nocsv = math.max(0, miss - nocsv*2), nocsv*2 else nocsv = nil end
	end

	if class == "PALADIN" then
		hotc, _, _, _, hotcv = GetTalentInfo(3,4)
		if hotcv > 0 then crit = crit + hotcv else hotcv = nil end
	end

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

	if hasHP or nocsv then
		tip:AddLine(" ")
		tip:AddLine("Hit Bonuses", 1,1,1)
		if hasHP then tip:AddLine(hasHP.. " |cffffffff(+1%)") end
		if nocsv then tip:AddLine(nocs.. "* |cffffffff(+"..nocsv.."%)") end
		if nocsv then tip:AddLine("*Dual-wield only", 0.5, 0.5, 1) end
	end

	if hotcv then
		tip:AddLine(" ")
		tip:AddLine("Crit Bonuses", 1,1,1)
		if hotcv then tip:AddLine(hotc.. "* |cffffffff(+"..hotcv.."%)") end
		if hotcv then tip:AddLine("*When debuff is applied", 0.5, 0.5, 1) end
	end

	tip:AddLine(" ")
	tip:AddLine("All values are vs. mobs 3 levels above the player, attacking |cffccffccfrom behind|r, with capped weapon skill.", 0,1,0, true)

	tip:Show()
end, tip)


local tip2 = LibStub("tektip-1.0").new(3, "LEFT", "RIGHT", "RIGHT")
tek_register("Interface\\Icons\\INV_Hammer_01", function(self)
	local hit, crit, miss, dodge, glance, parry, block = gettable(true, false, true)
	local shit, scrit, smiss, sdodge, sglance, sparry, sblock = gettable(false, false, true)


	tip2:SetPoint("BOTTOMLEFT", self, "TOPRIGHT")

	tip2:AddLine("Tank Melee Tables", 1,1,1)
	tip2:AddMultiLine("", "Normal", "Special")

	tip2:AddMultiLine(L["Critical"], string.format("%.2f%%", crit),   string.format("%.2f%%", scrit),   nil,nil,nil, .5,1,.5, .5,1,.5)
	tip2:AddMultiLine(L["Hit"],      string.format("%.2f%%", hit),    string.format("%.2f%%", shit),    nil,nil,nil, 1,1,1, 1,1,1)
	tip2:AddMultiLine(L["Miss"],     string.format("%.2f%%", miss),   string.format("%.2f%%", smiss),   nil,nil,nil, 1,.5,0, 1,.5,0)
	tip2:AddMultiLine(L["Dodge"],    string.format("%.2f%%", dodge),  string.format("%.2f%%", sdodge),  nil,nil,nil, 1,.5,0, 1,.5,0)
	tip2:AddMultiLine(L["Parry"],    string.format("%.2f%%", parry),  string.format("%.2f%%", sparry),  nil,nil,nil, 1,.5,0, 1,.5,0)
	tip2:AddMultiLine(L["Block"],    string.format("%.2f%%", block),  string.format("%.2f%%", sblock),  nil,nil,nil, 1,.5,0, 1,.5,0)
	tip2:AddMultiLine(L["Glancing"], string.format("%.2f%%", glance), string.format("%.2f%%", sglance), nil,nil,nil, 1,.5,0, 1,.5,0)

	if hasHP then
		tip2:AddLine(" ")
		tip2:AddLine("Hit Bonuses", 1,1,1)
		if hasHP then tip2:AddLine(hasHP.. " |cffffffff(+1%)") end
	end

	if hotcv then
		tip2:AddLine(" ")
		tip2:AddLine("Crit Bonuses", 1,1,1)
		if hotcv then tip2:AddLine(hotc.. "* |cffffffff(+"..hotcv.."%)") end
		if hotcv then tip2:AddLine("*When debuff is applied", 0.5, 0.5, 1) end
	end

	tip2:AddLine(" ")
	tip2:AddLine("All values are vs. mobs 3 levels above the player, attacking |cffccffccfrom in front|r, with capped weapon skill.", 0,1,0, true)

	tip2:Show()
end, tip2)
