local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Following/FollowingStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(p2)
	return asPromise((fetch({
		method = "POST",
		url = `{module2.Url.FRIEND_URL}/user/following-exists`,
		body = { targetUserIds = p2 },
		analyticsKey = "friends.get-following-exists",
		decode = function(p3)
			return p3
		end
	})))
end
