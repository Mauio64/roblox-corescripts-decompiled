local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Networking/myHttpRequest")

return function()
	return myHttpRequest(string.format("%s/user/trusted-friend-requests/count", url.FRIEND_URL), "GET"):andThen(function(p2)
		return p2 and p2.responseBody
	end)
end
