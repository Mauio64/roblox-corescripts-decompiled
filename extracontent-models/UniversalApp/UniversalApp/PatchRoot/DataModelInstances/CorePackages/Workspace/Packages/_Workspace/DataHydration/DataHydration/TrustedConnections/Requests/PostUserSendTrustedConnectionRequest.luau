local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local SharedFlags = require(DataHydrationParent.SharedFlags)
local Url = require(DataHydrationParent.Http).Url
local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p1, s1: string?) -- line: 10
	-- upvalues: Url (copy), SharedFlags (copy), myHttpRequest (copy)
	local v9 = string.format("%s/users/%s/send-trusted-friend-request", Url.FRIEND_URL, (tostring(p1)))

	if SharedFlags.FFlagProfilePlatformTrustedConnectionsMVP and s1 ~= nil then
		v9 ..= ("?source=%*"):format(s1)
	end

	return myHttpRequest(v9, "POST", {
		postBody = {}
	})
end
