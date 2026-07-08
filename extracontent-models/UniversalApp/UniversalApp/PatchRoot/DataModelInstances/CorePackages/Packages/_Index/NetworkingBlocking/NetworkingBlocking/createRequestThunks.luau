local networkRequests = script.Parent.networkRequests
local createGetBlockedUsers = require(networkRequests.createGetBlockedUsers)
local createBlockUserById = require(networkRequests.createBlockUserById)
local createUnblockUserById = require(networkRequests.createUnblockUserById)

return function(t1: {[any]: any}) -- line: 7
	-- upvalues: createGetBlockedUsers (copy), createBlockUserById (copy), createUnblockUserById (copy)
	return {
		GetBlockedUsers = createGetBlockedUsers(t1),
		BlockUserById = createBlockUserById(t1),
		UnblockUserById = createUnblockUserById(t1)
	}
end
