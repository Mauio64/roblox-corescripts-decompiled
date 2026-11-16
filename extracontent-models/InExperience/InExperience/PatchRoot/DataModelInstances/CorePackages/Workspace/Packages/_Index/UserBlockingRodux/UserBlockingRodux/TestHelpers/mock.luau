local parent = script:FindFirstAncestor("UserBlockingRodux").Parent
local Rodux = require(parent.Rodux)

return {
	mockBlockUserById = "BLOCK_USER_BY_ID_SUCCEEDED_ACTION",
	mockUnblockUserById = "UNBLOCK_USER_BY_ID_SUCCEEDED_ACTION",
	mockIsBlockedById = "IS_BLOCKED_BY_ID_SUCCEEDED_ACTION",
	mockBlockUserByIdAction = Rodux.makeActionCreator("BLOCK_USER_BY_ID_SUCCEEDED_ACTION", function(p)
		return {
			responseBody = {},
			namedIds = { users = p.userId }
		}
	end),
	mockUnblockUserByIdAction = Rodux.makeActionCreator("UNBLOCK_USER_BY_ID_SUCCEEDED_ACTION", function(p)
		return {
			responseBody = {},
			namedIds = { users = p.userId }
		}
	end),
	mockIsBlockedByIdAction = Rodux.makeActionCreator("IS_BLOCKED_BY_ID_SUCCEEDED_ACTION", function(p)
		return {
			responseBody = true,
			namedIds = { users = p.userId }
		}
	end)
}
