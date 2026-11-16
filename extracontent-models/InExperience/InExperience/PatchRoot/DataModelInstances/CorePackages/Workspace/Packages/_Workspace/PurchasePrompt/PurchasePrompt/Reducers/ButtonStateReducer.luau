local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local SetButtonState = require(PurchasePrompt.Actions.SetButtonState)
local ButtonState = require(PurchasePrompt.Enums.ButtonState)

return Rodux.createReducer(ButtonState.Enabled, {
	[SetButtonState.name] = function(_, p)
		return p.state
	end
})
