local PurchasePromptDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps")
local rodux = PurchasePromptDeps.Rodux
local cryo = PurchasePromptDeps.Cryo

local SetABVariation = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetABVariation")

return (rodux.createReducer({}, {
	[SetABVariation.name] = function(p2, p3)
		assert(type(p3.key) == "string", "Expected 'key' to be a string")
		assert(type(p3.variation) == "string", "Expected 'variation' to be a string")
		return cryo.Dictionary.join(p2, { [p3.key] = p3.variation })
	end
}))
