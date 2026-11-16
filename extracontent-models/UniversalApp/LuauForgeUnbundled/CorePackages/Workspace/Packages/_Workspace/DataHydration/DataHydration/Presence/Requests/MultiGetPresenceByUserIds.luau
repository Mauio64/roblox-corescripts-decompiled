local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/Networking/myHttpRequest")

return function(p2)
	return myHttpRequest(string.format("%s/presence/users", url.PRESENCE_URL), "POST", {
		postBody = { userIds = p2 }
	})
end
