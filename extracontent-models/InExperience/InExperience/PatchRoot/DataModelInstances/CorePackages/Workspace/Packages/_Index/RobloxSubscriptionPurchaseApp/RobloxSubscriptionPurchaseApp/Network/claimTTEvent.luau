local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local Promise = require(parent.Promise)

local function claimTTEvent()
	return Promise.resolve()
end

return claimTTEvent
