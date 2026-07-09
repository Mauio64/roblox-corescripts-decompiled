local GroupsNetworking = script:FindFirstAncestor("GroupsNetworking")
local GROUPS_URL = require(GroupsNetworking.GROUPS_URL)

return function(p1) -- line: 10
	-- upvalues: GROUPS_URL (copy)
	return p1.roduxNetworking.DELETE({
		Name = "RemovePrimaryGroup"
	}, function(p2) -- line: 13
		-- upvalues: GROUPS_URL (copy)
		return p2(GROUPS_URL):path("v1"):path("user"):path("groups"):path("primary")
	end)
end
