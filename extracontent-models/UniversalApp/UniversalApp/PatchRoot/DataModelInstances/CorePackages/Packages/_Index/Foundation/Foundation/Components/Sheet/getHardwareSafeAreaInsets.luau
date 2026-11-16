local Foundation = script:FindFirstAncestor("Foundation")

local Wrappers = require(Foundation.Utility.Wrappers)

local GuiService = Wrappers.Services.GuiService

local function getHardwareSafeAreaInsets()
	local insetArea = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
	local insetArea2 = GuiService:GetInsetArea(Enum.ScreenInsets.None)

	return {
		left = insetArea.Min.X - insetArea2.Min.X,
		top = insetArea.Min.Y - insetArea2.Min.Y,
		right = insetArea2.Max.X - insetArea.Max.X,
		bottom = insetArea2.Max.Y - insetArea.Max.Y
	}
end

return getHardwareSafeAreaInsets
