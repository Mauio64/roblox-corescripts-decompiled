local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Networking/myHttpRequest")

return function(p2, p3)
	return myHttpRequest(
		string.format("%s/users/%s/add-trusted-friend-from-link", url.FRIEND_URL, (tostring(p2))),
		"POST",
		{
			postBody = HttpService:JSONEncode({ Tokens = p3 })
		}
	)
end
