local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)

require(script.Parent.Parent.FriendsRequestsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function()
	return asPromise((fetch({
		method = "POST",
		url = `{Http.Url.FRIEND_URL}/user/friend-requests/decline-all`,
		body = {},
		analyticsKey = "friends.decline-all-friend-requests",
		decode = function(p)
			return p
		end
	})))
end
