local UserInputService = game:GetService("UserInputService")

local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local SetGamepadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetGamepadEnabled")

local v5 = UserInputService:GetPlatform() == Enum.Platform.XBoxOne
	or UserInputService:GetPlatform() == Enum.Platform.PS4
	or UserInputService:GetPlatform() == Enum.Platform.PS5

return (rodux.createReducer(v5, {
	[SetGamepadEnabled.name] = function(p2, p3)
		return p3.enabled
	end
}))
