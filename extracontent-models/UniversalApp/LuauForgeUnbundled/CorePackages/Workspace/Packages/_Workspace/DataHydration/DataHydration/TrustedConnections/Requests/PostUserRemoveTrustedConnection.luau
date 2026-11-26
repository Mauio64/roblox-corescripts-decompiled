local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Networking/myHttpRequest")

return function(p2)
	return myHttpRequest(
		string.format("%s/users/%s/remove-trusted-friend", url.FRIEND_URL, (tostring(p2))),
		"POST",
		{ postBody = {} }
	)
end
