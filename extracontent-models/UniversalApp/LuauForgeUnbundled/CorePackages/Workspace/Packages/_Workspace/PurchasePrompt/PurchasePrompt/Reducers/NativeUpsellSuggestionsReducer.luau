local rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").Rodux

local PromptNativeUpsellSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/PromptNativeUpsellSuggestions")

return rodux.createReducer({}, {
	[PromptNativeUpsellSuggestions.name] = function(p2, data)
		return {
			products = data.products,
			selection = data.selection,
			virtualItemBadgeType = data.virtualItemBadgeType,
			experimentVariant = data.experimentVariant
		}
	end
})
