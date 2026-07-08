local networkRequests = script.networkRequests
local createJoinGroup = require(networkRequests.createJoinGroup)
local createCancelJoinGroupRequest = require(networkRequests.createCancelJoinGroupRequest)
local createLeaveGroup = require(networkRequests.createLeaveGroup)
local createMakePrimaryGroup = require(networkRequests.createMakePrimaryGroup)
local createRemovePrimaryGroup = require(networkRequests.createRemovePrimaryGroup)

local function createRequestThunks(t1: {[any]: any}) -- line: 12
	-- upvalues: createJoinGroup (copy), createCancelJoinGroupRequest (copy), createLeaveGroup (copy), createMakePrimaryGroup (copy), createRemovePrimaryGroup (copy)
	return {
		JoinGroup = createJoinGroup(t1),
		CancelJoinGroupRequest = createCancelJoinGroupRequest(t1),
		LeaveGroup = createLeaveGroup(t1),
		MakePrimaryGroup = createMakePrimaryGroup(t1),
		RemovePrimaryGroup = createRemovePrimaryGroup(t1)
	}
end

return {
	config = createRequestThunks,
	["jest.config"] = script["jest.config"]
}
