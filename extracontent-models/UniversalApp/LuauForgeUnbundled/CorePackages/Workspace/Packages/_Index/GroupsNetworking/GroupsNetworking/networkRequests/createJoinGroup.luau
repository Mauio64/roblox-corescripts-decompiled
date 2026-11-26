local GROUPS_URL = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/GROUPS_URL")

return function(p2)
	return p2.roduxNetworking.POST("JoinGroup", function(callback, p3)
		return callback(GROUPS_URL):path("v1"):path("groups"):id(p3.groupId):path("users"):body({})
	end)
end
