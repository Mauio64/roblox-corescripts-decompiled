local RefreshExpectedPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RefreshExpectedPrice")
local SetProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetProductPayload")

local function applyRefreshedPrice(object, expectedPrice)
	object:dispatch(RefreshExpectedPrice(expectedPrice))

	local productPayload = object:getState().productPayload

	if productPayload then
		local clone = table.clone(productPayload)
		clone.expectedPrice = expectedPrice
		object:dispatch(SetProductPayload(clone))
	end
end

return applyRefreshedPrice
