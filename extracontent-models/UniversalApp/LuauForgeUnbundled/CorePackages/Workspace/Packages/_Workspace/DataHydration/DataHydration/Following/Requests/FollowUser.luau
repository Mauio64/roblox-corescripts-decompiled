local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Following/FollowingStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(p2, p3)
	return asPromise((fetch({
		method = "POST",
		url = `{module2.Url.FRIEND_URL}/users/{p2}/follow`,
		body = {},
		network = p3,
		analyticsKey = "friends.follow-user",
		legacy = true,
		decode = function(): nil
			return nil
		end
	})))
end
