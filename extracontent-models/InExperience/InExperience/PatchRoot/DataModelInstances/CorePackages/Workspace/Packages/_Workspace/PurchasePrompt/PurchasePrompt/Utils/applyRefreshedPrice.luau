local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")

local RefreshExpectedPrice = require(PurchasePrompt.Actions.RefreshExpectedPrice)
local SetProductPayload = require(PurchasePrompt.Actions.SetProductPayload)

local function applyRefreshedPrice(object, expectedPrice: number)
	object:dispatch(RefreshExpectedPrice(expectedPrice))

	local productPayload = object:getState().productPayload

	if productPayload then
		local clone = table.clone(productPayload)
		clone.expectedPrice = expectedPrice
		object:dispatch(SetProductPayload(clone))
	end
end

return applyRefreshedPrice
