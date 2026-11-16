local GroupsNetworking = script:FindFirstAncestor("GroupsNetworking")

local GROUPS_URL = require(GroupsNetworking.GROUPS_URL)

return function(p)
	return p.roduxNetworking.POST("MakePrimaryGroup", function(callback, p2)
		return callback(GROUPS_URL):path("v1"):path("user"):path("groups"):path("primary"):body({
			groupId = p2.groupId
		})
	end)
end
