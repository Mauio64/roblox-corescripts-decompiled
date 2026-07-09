local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

return function(p1, p2, p3, p4) -- line: 7
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	local v8 = UrlBuilder.fromString("apis:account-switcher/v1/switch")
	local json = HttpService:JSONEncode({
		switched_to_user_id = p2,
		switched_from_user_id = p4,
		encrypted_users_data_blob = p3
	})

	return p1(v8(), "POST", {
		postBody = json
	})
end
