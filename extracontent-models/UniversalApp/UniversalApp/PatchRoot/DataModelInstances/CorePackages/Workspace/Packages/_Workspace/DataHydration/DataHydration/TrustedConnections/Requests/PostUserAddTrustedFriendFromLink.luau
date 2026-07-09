local HttpService = game:GetService("HttpService")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Url = require(DataHydrationParent.Http).Url
local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p1, p2) -- line: 11
	-- upvalues: Url (copy), myHttpRequest (copy), HttpService (copy)
	local v9 = string.format("%s/users/%s/add-trusted-friend-from-link", Url.FRIEND_URL, (tostring(p1)))

	return myHttpRequest(v9, "POST", {
		postBody = HttpService:JSONEncode({
			Tokens = p2
		})
	})
end
