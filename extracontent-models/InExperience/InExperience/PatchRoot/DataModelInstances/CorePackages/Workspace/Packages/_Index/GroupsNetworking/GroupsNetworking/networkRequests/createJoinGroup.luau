local GroupsNetworking = script:FindFirstAncestor("GroupsNetworking")

local GROUPS_URL = require(GroupsNetworking.GROUPS_URL)

return function(p)
	return p.roduxNetworking.POST("JoinGroup", function(callback, p2)
		return callback(GROUPS_URL):path("v1"):path("groups"):id(p2.groupId):path("users"):body({})
	end)
end
