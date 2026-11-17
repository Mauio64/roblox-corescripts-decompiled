local UserInputService = game:GetService("UserInputService")

local function getChipDismissInput()
	return UserInputService.MouseEnabled, UserInputService.TouchEnabled
end

return getChipDismissInput
