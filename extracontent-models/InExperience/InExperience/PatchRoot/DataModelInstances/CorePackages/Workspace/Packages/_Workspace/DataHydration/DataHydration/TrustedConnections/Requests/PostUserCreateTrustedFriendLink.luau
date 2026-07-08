local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p1, _: string?) -- line: 9
	-- upvalues: Url (copy), myHttpRequest (copy)
	local v8 = string.format("%s/users/%s/create-trusted-friend-link", Url.FRIEND_URL, (tostring(p1)))

	return myHttpRequest(v8, "POST", {
		postBody = {}
	})
end
