local UserInputService = game:GetService("UserInputService")

return {
	connectInputChanged = function(onInputChanged)
		return UserInputService.InputChanged:Connect(onInputChanged)
	end,
	connectInputEnded = function(onInputEnded)
		return UserInputService.InputEnded:Connect(onInputEnded)
	end
}
