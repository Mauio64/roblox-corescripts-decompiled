local networkRequests = script.Parent.networkRequests
local createGetBlockedUsers = require(networkRequests.createGetBlockedUsers)
local createBlockUserById = require(networkRequests.createBlockUserById)
local createUnblockUserById = require(networkRequests.createUnblockUserById)
local createIsBlockedById = require(networkRequests.createIsBlockedById)

return function(p)
	return {
		GetBlockedUsers = createGetBlockedUsers(p),
		BlockUserById = createBlockUserById(p),
		UnblockUserById = createUnblockUserById(p),
		IsBlockedById = createIsBlockedById(p)
	}
end
