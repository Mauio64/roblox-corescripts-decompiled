local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local dispatchPurchaseForProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/dispatchPurchaseForProductPayload")

local v5 = {}

local function retryPurchaseAfterUpsell()
	return Thunk.new("retryPurchaseAfterUpsell", v5, function(object, p2)
		dispatchPurchaseForProductPayload(function(p3)
			object:dispatch(p3)
		end, object:getState().productPayload, nil, true)
	end)
end

return retryPurchaseAfterUpsell
