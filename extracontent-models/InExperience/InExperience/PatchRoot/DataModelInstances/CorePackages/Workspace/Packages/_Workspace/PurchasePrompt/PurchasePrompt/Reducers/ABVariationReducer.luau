local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local PurchasePromptDeps = require(PurchasePromptParent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux
local Cryo = PurchasePromptDeps.Cryo
local SetABVariation = require(PurchasePrompt.Actions.SetABVariation)

return (Rodux.createReducer({}, {
	[SetABVariation.name] = function(p1, p2) -- line: 10
		-- upvalues: Cryo (copy)
		assert(type(p2.key) == "string", "Expected 'key' to be a string")
		assert(type(p2.variation) == "string", "Expected 'variation' to be a string")

		return Cryo.Dictionary.join(p1, {
			[p2.key] = p2.variation
		})
	end
}))
