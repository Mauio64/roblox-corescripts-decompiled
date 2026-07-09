local Parent = script:FindFirstAncestor("UserBlockingRodux").Parent
local Rodux = require(Parent.Rodux)
local v3 = Rodux.makeActionCreator("BLOCK_USER_BY_ID_SUCCEEDED_ACTION", function(p1) -- line: 6
	return {
		responseBody = {},
		namedIds = {
			users = p1.userId
		}
	}
end)
local v4 = Rodux.makeActionCreator("UNBLOCK_USER_BY_ID_SUCCEEDED_ACTION", function(p2) -- line: 14
	return {
		responseBody = {},
		namedIds = {
			users = p2.userId
		}
	}
end)
local v5 = Rodux.makeActionCreator("IS_BLOCKED_BY_ID_SUCCEEDED_ACTION", function(p3) -- line: 22
	return {
		responseBody = true,
		namedIds = {
			users = p3.userId
		}
	}
end)

return {
	mockBlockUserById = "BLOCK_USER_BY_ID_SUCCEEDED_ACTION",
	mockUnblockUserById = "UNBLOCK_USER_BY_ID_SUCCEEDED_ACTION",
	mockIsBlockedById = "IS_BLOCKED_BY_ID_SUCCEEDED_ACTION",
	mockBlockUserByIdAction = v3,
	mockUnblockUserByIdAction = v4,
	mockIsBlockedByIdAction = v5
}
