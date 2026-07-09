local GroupsNetworking = script:FindFirstAncestor("GroupsNetworking")
local GROUPS_URL = require(GroupsNetworking.GROUPS_URL)

return function(p1) -- line: 15
	-- upvalues: GROUPS_URL (copy)
	return p1.roduxNetworking.DELETE({
		Name = "LeaveGroup"
	}, function(p2, t1: {[any]: any}) -- line: 18
		-- upvalues: GROUPS_URL (copy)
		return p2(GROUPS_URL):path("v1"):path("groups"):id(t1.groupId):path("users"):id(t1.userId)
	end)
end
