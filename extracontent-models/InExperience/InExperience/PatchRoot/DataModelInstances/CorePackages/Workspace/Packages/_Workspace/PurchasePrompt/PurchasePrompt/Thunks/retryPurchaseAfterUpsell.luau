local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local Thunk = require(PurchasePrompt.Thunk)
local dispatchPurchaseForProductPayload = require(PurchasePrompt.Utils.dispatchPurchaseForProductPayload)

local v = {}

local function retryPurchaseAfterUpsell()
	return Thunk.new(script.Name, v, function(object, _)
		dispatchPurchaseForProductPayload(function(p)
			object:dispatch(p)
		end, object:getState().productPayload, nil, true)
	end)
end

return retryPurchaseAfterUpsell
