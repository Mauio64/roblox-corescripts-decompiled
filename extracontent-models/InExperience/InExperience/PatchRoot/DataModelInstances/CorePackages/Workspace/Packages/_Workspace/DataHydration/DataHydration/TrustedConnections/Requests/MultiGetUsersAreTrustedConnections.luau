local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

return function(list)
	local localPlayerUserId = getLocalPlayerUserId()
	local urlEncode = HttpService:UrlEncode(table.concat(list, ","))

	return myHttpRequest(
		string.format(
			"%s/user/%s/multiget-are-trusted-friends?userids=%s",
			Url.FRIEND_URL,
			tostring(localPlayerUserId),
			urlEncode
		),
		"GET"
	):andThen(function(p)
		return p and p.responseBody and p.responseBody.trustedFriendsId
	end)
end
