local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local Responsive = require(Parent.Responsive)
local useProperty = require(Parent.GuiObjectUtils).useProperty

local function useIsStickyShortcutBarEnabled(p1, p2) -- line: 11
	-- upvalues: GuiService (copy), UserInputService (copy), Responsive (copy), useProperty (copy)
	local v9 = p1 or GuiService
	local v10 = p2 or UserInputService
	local v11 = Responsive.usePreferredInput()
	local v12 = Responsive.useOrientation()
	local v13 = useProperty(v10, "TouchEnabled")
	local v14 = useProperty(v10, "KeyboardEnabled")
	local v15 = useProperty(v9, "ViewportDisplaySize")

	if (v11 == Responsive.Input.Directional or v14) and v12 == Responsive.Keys.Landscape and (v13 or v15 ~= Enum.DisplaySize.Large) then
		return true
	end

	return false
end

return useIsStickyShortcutBarEnabled
