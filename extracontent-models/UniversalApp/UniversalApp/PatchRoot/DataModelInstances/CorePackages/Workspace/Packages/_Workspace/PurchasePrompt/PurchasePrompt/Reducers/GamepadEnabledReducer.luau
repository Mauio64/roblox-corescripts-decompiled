local UserInputService = game:GetService("UserInputService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetGamepadEnabled = require(PurchasePrompt.Actions.SetGamepadEnabled)
local v6 = UserInputService:GetPlatform() == Enum.Platform.XBoxOne or (UserInputService:GetPlatform() == Enum.Platform.PS4 or UserInputService:GetPlatform() == Enum.Platform.PS5)

return (Rodux.createReducer(v6, {
	[SetGamepadEnabled.name] = function(_, p2) -- line: 15
		return p2.enabled
	end
}))
