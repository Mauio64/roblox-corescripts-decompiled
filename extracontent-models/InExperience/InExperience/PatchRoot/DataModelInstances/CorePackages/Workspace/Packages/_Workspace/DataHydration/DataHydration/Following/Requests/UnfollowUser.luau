local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)

require(script.Parent.Parent.FollowingStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(p, network)
	return asPromise((fetch({
		method = "POST",
		url = `{Http.Url.FRIEND_URL}/users/{p}/unfollow`,
		body = {},
		network = network,
		analyticsKey = "friends.unfollow-user",
		legacy = true,
		decode = function(): nil
			return nil
		end
	})))
end
