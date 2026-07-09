local UserInputService = game:GetService("UserInputService")

local function getUserInputIsSelectionOnly() -- line: 3
	-- upvalues: UserInputService (copy)
	return not UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

return getUserInputIsSelectionOnly
