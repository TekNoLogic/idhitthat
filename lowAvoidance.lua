
local L = setmetatable({}, {__index=function(t,i) return i end})
tek_locale = L

---------------------------
--      Basic Panel      --
---------------------------

local f = CreateFrame("Button", nil, CharacterModelFrame)
f:SetFrameStrata("DIALOG")
f:SetPoint("BOTTOMRIGHT", -4, 25)
f:SetWidth(26) f:SetHeight(26)

local icons, onenters = {}, {}
function tek_register(icon, onenter)
	table.insert(onenters, onenter)
	icons[onenter] = icon
end


local tableindex, func
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon:lower() ~= "lowavoidance" then return end

	tableindex, func = 1, onenters[1]

	f:SetNormalTexture(icons[func])

	self:UnregisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", nil)
end)


local function changetable(self, ...)
	tableindex = tableindex + 1;
	if tableindex > #onenters then tableindex = 1 end
	func = onenters[tableindex]
	f:SetNormalTexture(icons[func])
	func(self)
 end
f:SetScript("OnClick", changetable)
f:SetScript("OnMouseWheel", changetable)
f:SetScript("OnLeave", function() GameTooltip:Hide() end)
f:SetScript("OnEnter", function(self, ...) func(self, ...) end)
f:EnableMouseWheel(true)
