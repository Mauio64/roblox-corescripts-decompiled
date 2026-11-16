local parent = script:FindFirstAncestor("AuthCommon").Parent

local Http = require(parent.Http)
local Url = Http.Url
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableLogoutV3 = SharedFlags.FFlagEnableLogoutV3

return function(callback)
	local v

	if FFlagEnableLogoutV3 then
		v = string.format("%sv3/logout", Url.AUTH_URL)
	else
		v = string.format("%sv1/logout", Url.AUTH_URL)
	end

	return callback(v, "POST", {
		postBody = FFlagEnableLogoutV3 and "{}" or "",
		maxRetryCount = 0
	})
end
