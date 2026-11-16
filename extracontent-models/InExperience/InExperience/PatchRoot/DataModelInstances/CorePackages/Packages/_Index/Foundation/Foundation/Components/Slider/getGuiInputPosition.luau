local Foundation = script:FindFirstAncestor("Foundation")

local Wrappers = require(Foundation.Utility.Wrappers)

local GuiService = Wrappers.Services.GuiService

local function getGuiInputPosition(vector2: Vector2, instance)
	local screenGui = instance:FindFirstAncestorWhichIsA("ScreenGui")

	if not (screenGui and screenGui.IgnoreGuiInset) then
		return vector2
	end

	local v

	if screenGui.ScreenInsets == Enum.ScreenInsets.DeviceSafeInsets then
		v = Enum.ScreenInsets.DeviceSafeInsets
	else
		v = Enum.ScreenInsets.None
	end

	return vector2 + GuiService:GetInsetArea(v).Min
end

return getGuiInputPosition
