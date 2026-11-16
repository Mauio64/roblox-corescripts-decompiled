local url = require("@luauforge/bundled/hIi").Url
local module = require("@luauforge/bundled/hIj")

return function(p2)
	return p2.roduxNetworking.GET("createGetUserSettingsPlatform", function(callback, p3, p4, p5)
		local v5 = if module == "" then url.APIS_URL else module
		local path = callback(v5, { crossPlaySettingsKey = p4 }):path("user-settings-api"):path("v1"):path("user-settings")

		if not p5 then
			path = path:path("platform")
		end

		return path:queryArgs({
			[p5 and "requestedUserSettings" or "requestedPlatformSettings"] = p3
		})
	end)
end
