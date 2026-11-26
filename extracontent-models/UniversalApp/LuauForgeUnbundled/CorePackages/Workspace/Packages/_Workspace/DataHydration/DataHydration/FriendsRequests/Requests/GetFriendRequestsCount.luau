local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRequests/FriendsRequestsStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function()
	return asPromise((fetch({
		method = "GET",
		url = `{module2.Url.FRIEND_URL}/user/friend-requests/count`,
		analyticsKey = "friends.get-friend-requests-count",
		decode = function(p2)
			return p2
		end
	})))
end
