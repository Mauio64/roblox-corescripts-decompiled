local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local Rodux = PurchasePromptDeps.Rodux

local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)

return Rodux.createReducer({}, {
	[PromptNativeUpsellSuggestions.name] = function(_, data)
		return {
			products = data.products,
			selection = data.selection,
			virtualItemBadgeType = data.virtualItemBadgeType,
			experimentVariant = data.experimentVariant
		}
	end
})
