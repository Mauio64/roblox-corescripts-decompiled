local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local Thunk = require(PurchasePrompt.Thunk)
local dispatchPurchaseForProductPayload = require(PurchasePrompt.Utils.dispatchPurchaseForProductPayload)
local t1 = {}

local function retryPurchaseAfterUpsell() -- line: 11
	-- upvalues: Thunk (copy), t1 (copy), dispatchPurchaseForProductPayload (copy)
	return Thunk.new(script.Name, t1, function(p1, _) -- line: 12
		-- upvalues: dispatchPurchaseForProductPayload (copy)
		local productPayload = p1:getState().productPayload

		dispatchPurchaseForProductPayload(function(p3) -- line: 16
			-- upvalues: p1 (copy)
			p1:dispatch(p3)
		end, productPayload, nil, true)
	end)
end

return retryPurchaseAfterUpsell
