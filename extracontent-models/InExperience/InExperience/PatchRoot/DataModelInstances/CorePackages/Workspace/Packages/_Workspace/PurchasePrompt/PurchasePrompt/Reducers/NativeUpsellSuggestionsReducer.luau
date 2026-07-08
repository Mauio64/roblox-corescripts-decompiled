local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Rodux = require(PurchasePromptParent.PurchasePromptDeps).Rodux
local PromptNativeUpsellSuggestions = require(PurchasePrompt.Actions.PromptNativeUpsellSuggestions)

return Rodux.createReducer({}, {
	[PromptNativeUpsellSuggestions.name] = function(_, p2) -- line: 9
		return {
			products = p2.products,
			selection = p2.selection,
			virtualItemBadgeType = p2.virtualItemBadgeType
		}
	end
})
