local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/FriendsRecommendationsStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(p2, p3)
	return asPromise((fetch({
		method = "GET",
		url = UrlBuilder.UrlBuilder.addQueryString(
			`{module2.Url.FRIEND_URL}/users/{p2}/friends/recommendations`,
			{ source = p3 }
		),
		analyticsKey = "friends.get-friend-recommendations",
		decode = function(p4)
			return p4
		end
	})))
end
