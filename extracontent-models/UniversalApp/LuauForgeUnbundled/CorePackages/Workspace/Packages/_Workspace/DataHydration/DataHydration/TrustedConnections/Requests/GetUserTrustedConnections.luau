local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Networking/myHttpRequest")

return function(p2)
	return myHttpRequest(
		string.format(
			"%s/users/%s/friends/find?&findFriendsType=FindTrustedFriends",
			url.FRIEND_URL,
			(tostring(p2))
		),
		"GET"
	):andThen(function(p3)
		return p3 and p3.responseBody
	end)
end
