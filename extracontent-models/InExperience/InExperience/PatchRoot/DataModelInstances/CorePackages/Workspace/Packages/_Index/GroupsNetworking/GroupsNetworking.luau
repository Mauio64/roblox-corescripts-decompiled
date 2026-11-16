local networkRequests = script.networkRequests
local createJoinGroup = require(networkRequests.createJoinGroup)
local createCancelJoinGroupRequest = require(networkRequests.createCancelJoinGroupRequest)
local createLeaveGroup = require(networkRequests.createLeaveGroup)
local createMakePrimaryGroup = require(networkRequests.createMakePrimaryGroup)
local createRemovePrimaryGroup = require(networkRequests.createRemovePrimaryGroup)

local function createRequestThunks(p)
	return {
		JoinGroup = createJoinGroup(p),
		CancelJoinGroupRequest = createCancelJoinGroupRequest(p),
		LeaveGroup = createLeaveGroup(p),
		MakePrimaryGroup = createMakePrimaryGroup(p),
		RemovePrimaryGroup = createRemovePrimaryGroup(p)
	}
end

return { config = createRequestThunks, ["jest.config"] = script["jest.config"] }
