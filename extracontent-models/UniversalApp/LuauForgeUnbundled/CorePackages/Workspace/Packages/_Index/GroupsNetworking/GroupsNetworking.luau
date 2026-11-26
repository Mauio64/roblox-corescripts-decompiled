local createJoinGroup = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/networkRequests/createJoinGroup")
local createCancelJoinGroupRequest = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/networkRequests/createCancelJoinGroupRequest")
local createLeaveGroup = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/networkRequests/createLeaveGroup")
local createMakePrimaryGroup = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/networkRequests/createMakePrimaryGroup")
local createRemovePrimaryGroup = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/networkRequests/createRemovePrimaryGroup")

local function createRequestThunks(p2)
	return {
		JoinGroup = createJoinGroup(p2),
		CancelJoinGroupRequest = createCancelJoinGroupRequest(p2),
		LeaveGroup = createLeaveGroup(p2),
		MakePrimaryGroup = createMakePrimaryGroup(p2),
		RemovePrimaryGroup = createRemovePrimaryGroup(p2)
	}
end

return { config = createRequestThunks }
