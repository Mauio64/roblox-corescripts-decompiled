local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url
local fFlagEnableLogoutV3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLogoutV3

return function(callback)
	local v5 = if fFlagEnableLogoutV3 then string.format("%sv3/logout", url.AUTH_URL) else string.format("%sv1/logout", url.AUTH_URL)

	return callback(v5, "POST", {
		postBody = fFlagEnableLogoutV3 and "{}" or "",
		maxRetryCount = 0
	})
end
