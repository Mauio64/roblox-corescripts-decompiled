local GroupsNetworking = script:FindFirstAncestor("GroupsNetworking")
local GROUPS_URL = require(GroupsNetworking.GROUPS_URL)

return function(p1) -- line: 14
	-- upvalues: GROUPS_URL (copy)
	return p1.roduxNetworking.POST({
		Name = "MakePrimaryGroup"
	}, function(p2, t1: {[any]: any}) -- line: 17
		-- upvalues: GROUPS_URL (copy)
		return p2(GROUPS_URL):path("v1"):path("user"):path("groups"):path("primary"):body({
			groupId = t1.groupId
		})
	end)
end
