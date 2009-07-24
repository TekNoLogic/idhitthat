
local L = tek_locale


local _, class = UnitClass("player")


tek_register("Interface\\Icons\\Spell_Holy_Aspiration", function(self)
	local hit = math.min(100, 83 + GetCombatRatingBonus(CR_HIT_SPELL))
	local crit = GetSpellCritChance(1)

	local hasHP = UnitAura("player", "Heroic Presence")
	if hasHP then hit = hit + 1 end

	local _, sf, sfv, deb, debv, dir, dirv, sup, supv, af, afv, hotc, hotcv

	if class == "PRIEST" then
		sf, _, _, _, sfv = GetTalentInfo(3,6)
		deb, _, _, _, debv = GetTalentInfo(3,22)
		if sfv > 0 then hit, sfv = hit + sfv, "+"..sfv.."%" else sfv = nil end
		if debv > 0 then hit, debv = hit + debv, "+"..debv.."%" else debv = nil end
	end

	if class == "DRUID" then
		dir, _, _, _, dirv = GetTalentInfo(1,17)
		deb, _, _, _, debv = GetTalentInfo(1,20)
		if dirv > 0 then hit, dirv = hit + dirv*2, "+"..(dirv*2).."%" else dirv = nil end
		if debv > 0 then hit, debv = hit + debv, "+"..(debv).."%" else debv = nil end
	end

	if class == "WARLOCK" then
		sup, _, _, _, supv = GetTalentInfo(1,2)
		if supv > 0 then hit, supv = hit + supv, "+"..supv.."%" else supv = nil end
	end

	if class == "MAGE" then
		af, _, _, _, afv = GetTalentInfo(1,2)
		dir, _, _, _, dirv = GetTalentInfo(3,6)
		if afv > 0 then hit, afv = hit + afv, "+"..afv.."%" else afv = nil end
		if dirv > 0 then hit, dirv = hit + dirv, "+"..dirv.."%" else dirv = nil end
	end

	if class == "DEATHKNIGHT" then
		dir, _, _, _, dirv = GetTalentInfo(3,2)
		if dirv > 0 then hit, dirv = hit + dirv, "+"..dirv.."%" else dirv = nil end
	end

	if class == "SHAMAN" then
		dir, _, _, _, dirv = GetTalentInfo(1,14)
		if dirv > 0 then hit, dirv = hit + dirv, "+"..dirv.."%" else dirv = nil end
	end

	if class == "PALADIN" then
		hotc, _, _, _, hotcv = GetTalentInfo(3,4)
		if hotcv > 0 then crit = crit + hotcv else hotcv = nil end
	end

	local miss = math.max(100 - hit, 0)
	crit = crit * hit/100
	hit = hit - crit


 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()

	GameTooltip:AddLine("Spell Table", 1,1,1)

	GameTooltip:AddDoubleLine(L["Critical"], string.format("%.2f%%", crit), nil,nil,nil, .5,1,.5)
	GameTooltip:AddDoubleLine(L["Hit"], string.format("%.2f%%", hit), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Miss"], string.format("%.2f%%", miss), nil,nil,nil, 1,.5,0)

	if hasHP or sfv or debv or sfv or dirv or supv or afv or dirv then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Hit Bonuses", 1,1,1)
		if hasHP then GameTooltip:AddDoubleLine(hasHP, "+1%", nil,nil,nil, 1,1,1) end
		if dirv  then GameTooltip:AddDoubleLine(dir, dirv, nil,nil,nil, 1,1,1) end
		if debv  then GameTooltip:AddDoubleLine(deb.."*", debv, nil,nil,nil, 1,1,1) end
		if sfv   then GameTooltip:AddDoubleLine(sf.."\194\186", sfv, nil,nil,nil, 1,1,1) end
		if supv  then GameTooltip:AddDoubleLine(sup, supv, nil,nil,nil, 1,1,1) end
		if afv   then GameTooltip:AddDoubleLine(af.."\194\186", afv, nil,nil,nil, 1,1,1) end

		if debv then GameTooltip:AddLine("*When debuff is applied", 0.5, 0.5, 1) end
		if sfv then GameTooltip:AddLine("\194\186Shadow spells only", 0.5, 0.5, 1) end
		if afv  then GameTooltip:AddLine("\194\186Arcane spells only", 0.5, 0.5, 1) end
	end

	if hotcv then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Crit Bonuses", 1,1,1)
		if hotcv then GameTooltip:AddDoubleLine(hotc.."*", "+"..hotcv.."%", nil,nil,nil, 1,1,1) end
		if hotcv then GameTooltip:AddLine("*When debuff is applied", 0.5, 0.5, 1) end
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("All values are vs. mobs\n3 levels above the player.", 0,1,0, true)

	GameTooltip:Show()
end)


tek_locale, tek_register = nil
