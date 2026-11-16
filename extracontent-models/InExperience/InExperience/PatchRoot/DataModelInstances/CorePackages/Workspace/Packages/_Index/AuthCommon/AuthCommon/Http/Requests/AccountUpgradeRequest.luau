local parent = script:FindFirstAncestor("AuthCommon").Parent

local HttpService = game:GetService("HttpService")

require(parent.Http)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, data)
	local v = urlBuilder.fromString("auth:v1/account/upgrade")

	local v2 = {
		upgradeType = data.upgradeType,
		username = data.username,
		password = 0,
		birthday = 0,
		email = 0,
		gender = 0
	}
	local password

	if data.password ~= "" then
		password = data.password
	end

	v2.password = password
	local birthday

	if data.birthday ~= "" then
		birthday = data.birthday
	end

	v2.birthday = birthday
	local email

	if data.email ~= "" then
		email = data.email
	end

	v2.email = email

	v2.gender = data.gender
	local jsonEncode = HttpService:JSONEncode(v2)

	return callback(v(), "POST", {
		postBody = jsonEncode,
		maxRetryCount = 0,
		headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	})
end
