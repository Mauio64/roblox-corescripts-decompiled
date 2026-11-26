local UserInputService = game:GetService("UserInputService")

return {
	getPlatform = function()
		return UserInputService:GetPlatform()
	end,
	statusReadTimeoutSeconds = 1
}
