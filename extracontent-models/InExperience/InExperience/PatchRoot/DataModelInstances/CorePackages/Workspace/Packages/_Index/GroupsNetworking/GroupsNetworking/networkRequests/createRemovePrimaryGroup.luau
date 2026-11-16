local GroupsNetworking = script:FindFirstAncestor("GroupsNetworking")

local GROUPS_URL = require(GroupsNetworking.GROUPS_URL)

return function(p)
	return p.roduxNetworking.DELETE("RemovePrimaryGroup", function(callback)
		return callback(GROUPS_URL):path("v1"):path("user"):path("groups"):path("primary")
	end)
end
