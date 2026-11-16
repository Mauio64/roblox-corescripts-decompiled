local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)

require(script.Parent.Parent.FollowingStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(targetUserIds)
	return asPromise((fetch({
		method = "POST",
		url = `{Http.Url.FRIEND_URL}/user/following-exists`,
		body = { targetUserIds = targetUserIds },
		analyticsKey = "friends.get-following-exists",
		decode = function(p)
			return p
		end
	})))
end
