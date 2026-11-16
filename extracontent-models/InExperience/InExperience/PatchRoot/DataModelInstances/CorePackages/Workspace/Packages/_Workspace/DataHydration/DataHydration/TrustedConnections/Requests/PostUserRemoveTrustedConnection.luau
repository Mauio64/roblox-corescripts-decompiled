local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p)
	return myHttpRequest(string.format("%s/users/%s/remove-trusted-friend", Url.FRIEND_URL, (tostring(p))), "POST", {
		postBody = {}
	})
end
