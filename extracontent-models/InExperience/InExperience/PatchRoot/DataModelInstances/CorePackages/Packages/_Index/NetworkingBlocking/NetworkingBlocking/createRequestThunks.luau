local networkRequests = script.Parent.networkRequests
local createGetBlockedUsers = require(networkRequests.createGetBlockedUsers)
local createBlockUserById = require(networkRequests.createBlockUserById)
local createUnblockUserById = require(networkRequests.createUnblockUserById)

return function(p)
	return {
		GetBlockedUsers = createGetBlockedUsers(p),
		BlockUserById = createBlockUserById(p),
		UnblockUserById = createUnblockUserById(p)
	}
end
