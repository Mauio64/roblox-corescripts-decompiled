local HttpService = game:GetService("HttpService")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p, tokens)
	return myHttpRequest(
		string.format("%s/users/%s/add-trusted-friend-from-link", Url.FRIEND_URL, (tostring(p))),
		"POST",
		{
			postBody = HttpService:JSONEncode({ Tokens = tokens })
		}
	)
end
