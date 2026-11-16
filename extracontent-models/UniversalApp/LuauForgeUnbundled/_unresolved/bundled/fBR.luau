require("@game/CorePackages/Workspace/Packages/Http")
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local fFlagEnableLogoutV3 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableLogoutV3
local HttpService = game:GetService("HttpService")

return function(callback, logoutReason, url, userId)
	local v5 = string.format("%sv1/logout", Url.AUTH_URL)

	if not fFlagEnableLogoutV3 then
		return callback(v5, "POST", { postBody = "", maxRetryCount = 0 })
	end

	local v6 = string.format("%sv3/logout", Url.AUTH_URL)
	local v7 = {}

	if logoutReason then
		v7.logoutReason = logoutReason
	end

	if url then
		v7.url = url
	end

	if userId then
		v7.userId = userId
	end

	return callback(v6, "POST", {
		postBody = HttpService:JSONEncode(v7),
		maxRetryCount = 0
	})
end
