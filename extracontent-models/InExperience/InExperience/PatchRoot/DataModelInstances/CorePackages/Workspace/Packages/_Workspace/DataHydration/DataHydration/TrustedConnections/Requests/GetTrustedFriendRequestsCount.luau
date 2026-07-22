local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function() -- line: 9
	-- upvalues: Url (copy), myHttpRequest (copy)
	local v6 = string.format("%s/user/trusted-friend-requests/count", Url.FRIEND_URL)

	return myHttpRequest(v6, "GET"):andThen(function(p1) -- line: 12
		return p1 and p1.responseBody
	end)
end
