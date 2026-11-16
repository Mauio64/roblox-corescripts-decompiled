local url = require("@luauforge/bundled/hIi").Url
local module = require("@luauforge/bundled/hIj")

return function(p2)
	return p2.roduxNetworking.POST("createUpdateUserSettingsPlatform", function(callback, p3, p4, p5, p6)
		local v5 = if module == "" then url.APIS_URL else module
		local path = callback(v5, { crossPlaySettingsKey = p4, crossPlayValue = p5 }):path("user-settings-api"):path("v1"):path("user-settings")

		if not p6 then
			path = path:path("platform")
		end

		return path:body({ [p3] = p5 })
	end)
end
