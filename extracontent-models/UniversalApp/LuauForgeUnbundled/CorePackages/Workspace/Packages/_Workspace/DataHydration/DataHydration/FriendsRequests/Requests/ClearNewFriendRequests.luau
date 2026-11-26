local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function()
	return asPromise((fetch({
		method = "DELETE",
		url = `{module2.Url.FRIEND_URL}/my/new-friend-requests`,
		analyticsKey = "friends.clear-new-friend-requests",
		decode = function(p2): nil
			return nil
		end
	})))
end
