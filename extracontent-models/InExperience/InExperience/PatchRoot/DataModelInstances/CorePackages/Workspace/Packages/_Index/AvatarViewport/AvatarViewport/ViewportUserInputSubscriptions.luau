local UserInputService = game:GetService("UserInputService")
local ViewportUserInputSubscriptions = {}

function ViewportUserInputSubscriptions.connectInputChanged(onInputChanged)
	return UserInputService.InputChanged:Connect(onInputChanged)
end

function ViewportUserInputSubscriptions.connectInputEnded(onInputEnded)
	return UserInputService.InputEnded:Connect(onInputEnded)
end

return ViewportUserInputSubscriptions
