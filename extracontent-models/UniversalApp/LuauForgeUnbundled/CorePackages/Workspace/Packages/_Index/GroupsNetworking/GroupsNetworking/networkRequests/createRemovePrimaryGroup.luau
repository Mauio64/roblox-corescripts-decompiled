local GROUPS_URL = require("@game/CorePackages/Workspace/Packages/_Index/GroupsNetworking/GroupsNetworking/GROUPS_URL")

return function(p2)
	return p2.roduxNetworking.DELETE("RemovePrimaryGroup", function(callback)
		return callback(GROUPS_URL):path("v1"):path("user"):path("groups"):path("primary")
	end)
end
