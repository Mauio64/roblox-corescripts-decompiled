local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId

return function(p1) -- line: 11
	-- upvalues: getLocalPlayerUserId (copy), HttpService (copy), Url (copy), myHttpRequest (copy)
	local v9 = getLocalPlayerUserId()
	local v10 = HttpService:UrlEncode(table.concat(p1, ","))
	local v11 = string.format("%s/user/%s/multiget-are-trusted-friends?userids=%s", Url.FRIEND_URL, tostring(v9), v10)

	return myHttpRequest(v11, "GET"):andThen(function(p2) -- line: 22
		return p2 and (p2.responseBody and p2.responseBody.trustedFriendsId)
	end)
end
