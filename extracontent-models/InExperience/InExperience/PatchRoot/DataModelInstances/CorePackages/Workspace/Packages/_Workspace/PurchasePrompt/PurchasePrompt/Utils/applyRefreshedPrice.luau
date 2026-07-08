local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local RefreshExpectedPrice = require(PurchasePrompt.Actions.RefreshExpectedPrice)
local SetProductPayload = require(PurchasePrompt.Actions.SetProductPayload)

local function applyRefreshedPrice(p1, n1: number) -- line: 6
	-- upvalues: RefreshExpectedPrice (copy), SetProductPayload (copy)
	p1:dispatch(RefreshExpectedPrice(n1))

	local productPayload = p1:getState().productPayload

	if productPayload then
		local v8 = table.clone(productPayload)

		v8.expectedPrice = n1
		p1:dispatch(SetProductPayload(v8))
	end
end

return applyRefreshedPrice
