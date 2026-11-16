local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(p2, data)
	if p2 == nil or tostring(p2) == "" then
		return Promise.reject("SearchFriendsByQuery called with nil userId")
	end

	return asPromise((fetch({
		method = "GET",
		url = UrlBuilder.UrlBuilder.addQueryString(`{module.Url.FRIEND_URL}/users/{p2}/friends/search`, {
			query = data.query,
			limit = data.limit,
			cursor = data.cursor
		}),
		analyticsKey = "friends.search-friends",
		decode = function(p3)
			return p3
		end
	})))
end
