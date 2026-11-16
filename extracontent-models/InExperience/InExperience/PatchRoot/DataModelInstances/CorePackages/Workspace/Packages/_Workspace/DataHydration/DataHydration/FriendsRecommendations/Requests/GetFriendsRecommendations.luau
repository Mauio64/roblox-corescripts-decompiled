local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)

require(script.Parent.Parent.FriendsRecommendationsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(p: string, source: string?)
	return asPromise((fetch({
		method = "GET",
		url = UrlBuilder.UrlBuilder.addQueryString(`{Http.Url.FRIEND_URL}/users/{p}/friends/recommendations`, {
			source = source
		}),
		analyticsKey = "friends.get-friend-recommendations",
		decode = function(p2)
			return p2
		end
	})))
end
