local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local GuiService = require(Foundation.Utility.Wrappers).Services.GuiService

local function getHardwareSafeAreaInsets() -- line: 9
	-- upvalues: GuiService (copy)
	local InsetArea = GuiService:GetInsetArea(Enum.ScreenInsets.DeviceSafeInsets)
	local InsetArea2 = GuiService:GetInsetArea(Enum.ScreenInsets.None)

	return {
		left = InsetArea.Min.X - InsetArea2.Min.X,
		top = InsetArea.Min.Y - InsetArea2.Min.Y,
		right = InsetArea2.Max.X - InsetArea.Max.X,
		bottom = InsetArea2.Max.Y - InsetArea.Max.Y
	}
end

return getHardwareSafeAreaInsets
