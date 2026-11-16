local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)
local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(p, data)
	if p == nil or tostring(p) == "" then
		return Promise.reject("SearchFriendsByQuery called with nil userId")
	end

	return asPromise((fetch({
		method = "GET",
		url = UrlBuilder.UrlBuilder.addQueryString(`{Http.Url.FRIEND_URL}/users/{p}/friends/search`, {
			query = data.query,
			limit = data.limit,
			cursor = data.cursor
		}),
		analyticsKey = "friends.search-friends",
		decode = function(p2)
			return p2
		end
	})))
end
