local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url

local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Networking/myHttpRequest")

return function(p2, p3)
	local v5 = string.format("%s/users/%s/send-trusted-friend-request", url.FRIEND_URL, (tostring(p2)))

	if SharedFlags.FFlagProfilePlatformTrustedConnectionsMVP and p3 ~= nil then
		v5 ..= `?source={p3}`
	end

	return myHttpRequest(v5, "POST", { postBody = {} })
end
