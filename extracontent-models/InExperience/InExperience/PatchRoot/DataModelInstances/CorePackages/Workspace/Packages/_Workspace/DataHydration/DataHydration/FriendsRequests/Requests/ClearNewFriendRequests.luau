local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function()
	return asPromise((fetch({
		method = "DELETE",
		url = `{Http.Url.FRIEND_URL}/my/new-friend-requests`,
		analyticsKey = "friends.clear-new-friend-requests",
		decode = function(_): nil
			return nil
		end
	})))
end
