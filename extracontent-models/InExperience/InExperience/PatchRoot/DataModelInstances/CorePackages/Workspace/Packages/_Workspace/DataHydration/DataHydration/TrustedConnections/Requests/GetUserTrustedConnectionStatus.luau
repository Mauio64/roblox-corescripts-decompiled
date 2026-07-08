local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p1) -- line: 9
	-- upvalues: Url (copy), myHttpRequest (copy)
	local v7 = string.format("%s/my/trusted-friends/%s/status", Url.FRIEND_URL, (tostring(p1)))

	return myHttpRequest(v7, "GET"):andThen(function(p2) -- line: 11
		return p2 and (p2.responseBody and p2.responseBody.status)
	end)
end
