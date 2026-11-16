local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder

return function(callback, data)
	local v5 = urlBuilder.fromString("auth:v1/account/upgrade")

	local v7 = {
		upgradeType = data.upgradeType,
		username = data.username,
		password = 0,
		birthday = 0,
		email = 0,
		gender = 0
	}

	local v8 = if data.password ~= "" then data.password else nil
	v7.password = v8

	local v9 = if data.birthday ~= "" then data.birthday else nil
	v7.birthday = v9

	local v10 = if data.email ~= "" then data.email else nil
	v7.email = v10

	v7.gender = data.gender
	local jsonEncode = HttpService:JSONEncode(v7)

	return callback(v5(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0,
		headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	})
end
