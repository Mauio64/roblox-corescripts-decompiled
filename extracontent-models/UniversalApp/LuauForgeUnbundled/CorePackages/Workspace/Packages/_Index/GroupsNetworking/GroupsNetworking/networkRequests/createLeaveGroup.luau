local GROUPS_URL = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/GROUPS_URL")

return function(p2)
	return p2.roduxNetworking.DELETE("LeaveGroup", function(callback, p3)
		return callback(GROUPS_URL):path("v1"):path("groups"):id(p3.groupId):path("users"):id(p3.userId)
	end)
end
