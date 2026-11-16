local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function()
	return myHttpRequest(string.format("%s/user/trusted-friend-requests/count", Url.FRIEND_URL), "GET"):andThen(function(p)
		return p and p.responseBody
	end)
end
