local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local SetButtonState = require(PurchasePrompt.Actions.SetButtonState)
local ButtonState = require(PurchasePrompt.Enums.ButtonState)

return Rodux.createReducer(ButtonState.Enabled, {
	[SetButtonState.name] = function(_, p2) -- line: 11
		return p2.state
	end
})
