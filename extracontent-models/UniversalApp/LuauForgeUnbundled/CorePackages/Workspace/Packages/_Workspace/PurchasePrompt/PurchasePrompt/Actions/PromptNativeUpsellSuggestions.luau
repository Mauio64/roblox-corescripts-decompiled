local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Rodux").makeActionCreator
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Models/RobuxUpsell")

local actionCreator = makeActionCreator("PromptNativeUpsellSuggestions", function(p2, p3, p4, p5)
	return {
		products = p2,
		selection = p3,
		virtualItemBadgeType = p4,
		experimentVariant = p5
	}
end)

local v5 = {
	name = actionCreator.name,
	__call = function(p2, p3, p4, p5, p6)
		return actionCreator(p3, p4, p5, p6)
	end
}

setmetatable(v5, v5)

return v5
