local GuiService = game:GetService("GuiService")

local function getAndroidBackSignal()
	return GuiService.ShowLeaveConfirmation
end

return getAndroidBackSignal
