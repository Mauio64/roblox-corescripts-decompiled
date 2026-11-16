local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function()
	return myHttpRequest(string.format("%s/user/trusted-friend-requests/ignore-all", Url.FRIEND_URL), "POST", {
		postBody = {}
	})
end
