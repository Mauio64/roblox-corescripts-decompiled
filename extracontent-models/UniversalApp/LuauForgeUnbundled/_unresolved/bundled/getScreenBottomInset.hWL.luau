local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local function getScreenBottomInset()
	if _G.__TESTEZ_RUNNING_TEST__ then
		return 0
	end

	local y = UserInputService.BottomBarSize.Y
	local bottom = GuiService:GetSafeZoneOffsets().bottom

	return y == 0 and bottom or y
end

return getScreenBottomInset
