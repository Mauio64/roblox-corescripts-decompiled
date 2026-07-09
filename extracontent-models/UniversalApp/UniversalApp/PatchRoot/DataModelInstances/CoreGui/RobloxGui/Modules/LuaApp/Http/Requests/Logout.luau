local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(CorePackages.Workspace.Packages.Http)

local Url = require(Modules.LuaApp.Http.Url)
local FFlagEnableLogoutV3 = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLogoutV3
local HttpService = game:GetService("HttpService")

return function(p1, s1: string?, s2: string?, s3: string?) -- line: 10
	-- upvalues: Url (copy), FFlagEnableLogoutV3 (copy), HttpService (copy)
	local v11 = string.format("%sv1/logout", Url.AUTH_URL)

	if FFlagEnableLogoutV3 then
		local v12 = string.format("%sv3/logout", Url.AUTH_URL)
		local t1 = {}

		if s1 then
			t1.logoutReason = s1
		end

		if s2 then
			t1.url = s2
		end

		if s3 then
			t1.userId = s3
		end

		local json = HttpService:JSONEncode(t1)

		return p1(v12, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end

	return p1(v11, "POST", {
		postBody = "",
		maxRetryCount = 0
	})
end
