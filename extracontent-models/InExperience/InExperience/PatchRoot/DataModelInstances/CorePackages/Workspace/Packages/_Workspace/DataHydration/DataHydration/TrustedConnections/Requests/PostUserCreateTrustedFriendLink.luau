local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p, _: string?)
	return myHttpRequest(
		string.format("%s/users/%s/create-trusted-friend-link", Url.FRIEND_URL, (tostring(p))),
		"POST",
		{ postBody = {} }
	)
end
