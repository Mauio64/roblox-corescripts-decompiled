local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Networking/myHttpRequest")
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

return function(list)
	local localPlayerUserId = getLocalPlayerUserId()
	local urlEncode = HttpService:UrlEncode(table.concat(list, ","))

	return myHttpRequest(
		string.format(
			"%s/user/%s/multiget-are-trusted-friends?userids=%s",
			url.FRIEND_URL,
			tostring(localPlayerUserId),
			urlEncode
		),
		"GET"
	):andThen(function(p2)
		return p2 and p2.responseBody and p2.responseBody.trustedFriendsId
	end)
end
