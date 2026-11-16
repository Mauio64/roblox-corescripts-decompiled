local networkRequests = script.networkRequests
local createGetUserPremiumMembershipStatus = require(networkRequests.createGetUserPremiumMembershipStatus)

local function createRequestThunks(p)
	return {
		GetUserPremiumMembershipStatus = createGetUserPremiumMembershipStatus(p)
	}
end

return { config = createRequestThunks }
