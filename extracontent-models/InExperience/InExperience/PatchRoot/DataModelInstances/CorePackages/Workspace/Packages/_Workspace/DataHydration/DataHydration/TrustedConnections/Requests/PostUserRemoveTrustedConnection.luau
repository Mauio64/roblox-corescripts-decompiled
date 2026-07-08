local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p1) -- line: 9
	-- upvalues: Url (copy), myHttpRequest (copy)
	local v7 = string.format("%s/users/%s/remove-trusted-friend", Url.FRIEND_URL, (tostring(p1)))

	return myHttpRequest(v7, "POST", {
		postBody = {}
	})
end
