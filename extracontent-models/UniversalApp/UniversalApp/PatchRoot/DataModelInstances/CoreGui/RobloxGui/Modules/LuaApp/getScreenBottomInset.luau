local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local function getScreenBottomInset() -- line: 4
	-- upvalues: UserInputService (copy), GuiService (copy)
	if not _G.__TESTEZ_RUNNING_TEST__ then
		local BottomBarSizeY = UserInputService.BottomBarSize.Y
		local bottom = GuiService:GetSafeZoneOffsets().bottom

		return BottomBarSizeY == 0 and bottom or BottomBarSizeY
	end

	return 0
end

return getScreenBottomInset
