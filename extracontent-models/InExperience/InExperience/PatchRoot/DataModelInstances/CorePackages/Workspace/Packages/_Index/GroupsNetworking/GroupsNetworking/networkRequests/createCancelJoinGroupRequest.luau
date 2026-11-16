local GroupsNetworking = script:FindFirstAncestor("GroupsNetworking")

local GROUPS_URL = require(GroupsNetworking.GROUPS_URL)

return function(p)
	return p.roduxNetworking.DELETE("CancelJoinGroupRequest", function(callback, p2)
		return callback(GROUPS_URL):path("v1"):path("groups"):id(p2.groupId):path("join-requests"):path("users"):id(p2.userId)
	end)
end
