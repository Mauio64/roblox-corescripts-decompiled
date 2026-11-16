local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local SharedFlags = require(parent.SharedFlags)
local Http = require(parent.Http)
local Url = Http.Url

local TrustedConnections = DataHydration.TrustedConnections
local myHttpRequest = require(TrustedConnections.Networking.myHttpRequest)

return function(p, p2: string?)
	local v = string.format("%s/users/%s/send-trusted-friend-request", Url.FRIEND_URL, (tostring(p)))

	if SharedFlags.FFlagProfilePlatformTrustedConnectionsMVP and p2 ~= nil then
		v ..= `?source={p2}`
	end

	return myHttpRequest(v, "POST", { postBody = {} })
end
