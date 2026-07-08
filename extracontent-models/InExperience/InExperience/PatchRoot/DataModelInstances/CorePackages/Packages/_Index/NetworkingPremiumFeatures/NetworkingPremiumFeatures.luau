local networkRequests = script.networkRequests
local createGetUserPremiumMembershipStatus = require(networkRequests.createGetUserPremiumMembershipStatus)

local function createRequestThunks(p1) -- line: 4
	-- upvalues: createGetUserPremiumMembershipStatus (copy)
	return {
		GetUserPremiumMembershipStatus = createGetUserPremiumMembershipStatus(p1)
	}
end

return {
	config = createRequestThunks
}
