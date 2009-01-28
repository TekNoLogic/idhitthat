
local L = setmetatable({}, {__index=function(t,i) return i end})
tek_locale = L

---------------------------
--      Basic Panel      --
---------------------------

local f = CreateFrame("Button", nil, CharacterModelFrame)
f:SetFrameStrata("DIALOG")
f:SetPoint("BOTTOMRIGHT", -4, 25)
f:SetWidth(26) f:SetHeight(26)

local icons, onenters, tips = {}, {}, {}
function tek_register(icon, onenter, tip)
	table.insert(onenters, onenter)
	icons[onenter] = icon
	if tip then tips[tip] = true end
end


local func
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon:lower() ~= "lowavoidance" then return end

	lowAvoidanceDBPC = lowAvoidanceDBPC or 1
	func = onenters[lowAvoidanceDBPC]

	f:SetNormalTexture(icons[func])

	self:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
end)


local function changetable(self, v)
	local diff = type(v) == "number" and v or 1
	lowAvoidanceDBPC = lowAvoidanceDBPC + diff
	if lowAvoidanceDBPC > #onenters then lowAvoidanceDBPC = 1 end
	if lowAvoidanceDBPC < 1 then lowAvoidanceDBPC = #onenters end
	func = onenters[lowAvoidanceDBPC]
	f:SetNormalTexture(icons[func])
	GameTooltip:Hide()
	for tip in pairs(tips) do tip:Hide() end
	func(self)
end
f:SetScript("OnClick", changetable)
f:SetScript("OnMouseWheel", changetable)
f:SetScript("OnLeave", function() GameTooltip:Hide() for tip in pairs(tips) do tip:Hide() end end)
f:SetScript("OnEnter", function(self, ...) func(self, ...) end)
f:EnableMouseWheel(true)
