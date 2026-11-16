local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator
require(PurchasePrompt.Models.RobuxUpsell)

local actionCreator = makeActionCreator(
	script.Name,
	function(products, selection: number, virtualItemBadgeType: string, experimentVariant: string?)
		return {
			products = products,
			selection = selection,
			virtualItemBadgeType = virtualItemBadgeType,
			experimentVariant = experimentVariant
		}
	end
)

local PromptNativeUpsellSuggestions = {
	name = actionCreator.name,
	__call = function(_, p, p2: number, p3: string, p4: string?)
		return actionCreator(p, p2, p3, p4)
	end
}

setmetatable(PromptNativeUpsellSuggestions, PromptNativeUpsellSuggestions)

return PromptNativeUpsellSuggestions
