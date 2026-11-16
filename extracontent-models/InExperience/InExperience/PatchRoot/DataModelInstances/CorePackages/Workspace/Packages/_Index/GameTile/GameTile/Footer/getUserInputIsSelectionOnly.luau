local UserInputService = game:GetService("UserInputService")

local function getUserInputIsSelectionOnly(): boolean
	return not (UserInputService.TouchEnabled or UserInputService.MouseEnabled)
end

return getUserInputIsSelectionOnly
