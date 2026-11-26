local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Networking/myHttpRequest")

return function()
	return myHttpRequest(string.format("%s/user/trusted-friend-requests/ignore-all", url.FRIEND_URL), "POST", {
		postBody = {}
	})
end
