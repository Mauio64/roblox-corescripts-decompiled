local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p)
	return myHttpRequest(string.format("%s/my/trusted-friends/%s/status", Url.FRIEND_URL, (tostring(p))), "GET"):andThen(function(p2)
		return p2 and p2.responseBody and p2.responseBody.status
	end)
end
