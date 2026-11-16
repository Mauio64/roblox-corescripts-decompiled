local GROUPS_URL = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/GROUPS_URL")

return function(p2)
	return p2.roduxNetworking.POST("MakePrimaryGroup", function(callback, p3)
		return callback(GROUPS_URL):path("v1"):path("user"):path("groups"):path("primary"):body({
			groupId = p3.groupId
		})
	end)
end
