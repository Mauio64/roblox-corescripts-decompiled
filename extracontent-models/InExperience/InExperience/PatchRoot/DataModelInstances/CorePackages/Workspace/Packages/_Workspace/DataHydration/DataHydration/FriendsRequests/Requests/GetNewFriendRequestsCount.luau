local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)

require(script.Parent.Parent.FriendsRequestsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function()
	return asPromise((fetch({
		method = "GET",
		url = `{Http.Url.FRIEND_URL}/my/new-friend-requests/count`,
		analyticsKey = "friends.get-new-friend-requests-count",
		decode = function(p)
			return p
		end
	})))
end
