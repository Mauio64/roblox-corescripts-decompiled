local UserInputService = game:GetService("UserInputService")

local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetGamepadEnabled = require(PurchasePrompt.Actions.SetGamepadEnabled)

local v = UserInputService:GetPlatform() == Enum.Platform.XBoxOne
	or UserInputService:GetPlatform() == Enum.Platform.PS4
	or UserInputService:GetPlatform() == Enum.Platform.PS5

return (Rodux.createReducer(v, {
	[SetGamepadEnabled.name] = function(_, p)
		return p.enabled
	end
}))
