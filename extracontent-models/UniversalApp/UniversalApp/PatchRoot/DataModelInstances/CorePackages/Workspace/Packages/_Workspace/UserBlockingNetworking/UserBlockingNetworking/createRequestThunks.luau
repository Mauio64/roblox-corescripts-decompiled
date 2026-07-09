local networkRequests = script.Parent.networkRequests
local createGetBlockedUsers = require(networkRequests.createGetBlockedUsers)
local createBlockUserById = require(networkRequests.createBlockUserById)
local createUnblockUserById = require(networkRequests.createUnblockUserById)
local createIsBlockedById = require(networkRequests.createIsBlockedById)

return function(t1: {[any]: any}) -- line: 8
	-- upvalues: createGetBlockedUsers (copy), createBlockUserById (copy), createUnblockUserById (copy), createIsBlockedById (copy)
	return {
		GetBlockedUsers = createGetBlockedUsers(t1),
		BlockUserById = createBlockUserById(t1),
		UnblockUserById = createUnblockUserById(t1),
		IsBlockedById = createIsBlockedById(t1)
	}
end
