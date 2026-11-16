local HttpService = game:GetService("HttpService")
local parent = script.Parent.Parent.Parent
local FFlagRoCaptchaReturnToServerInstance = require(parent.Common.Flags.FFlagRoCaptchaReturnToServerInstance)
local RoCaptchaUtils = {}

function RoCaptchaUtils.isUniverseAllowed(value: string, p: number): boolean
	local v = tostring(p)

	for k in string.gmatch(value, "[^,]+") do
		if string.match(k, "^%s*(.-)%s*$") == v then
			return true
		end
	end

	return false
end

function RoCaptchaUtils.parseLaunchData(value)
	if type(value) ~= "string" or value == "" then
		return nil
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, value)

	if not success or type(result) ~= "table" then
		return nil
	end

	local challengeId = result.challengeId
	local desiredPlaceId = tonumber(result.desiredPlaceId)

	if type(challengeId) ~= "string" or challengeId == "" then
		return nil
	end

	if not desiredPlaceId or desiredPlaceId <= 0 or desiredPlaceId % 1 ~= 0 then
		return nil
	end

	local serverInstanceId

	if FFlagRoCaptchaReturnToServerInstance then
		serverInstanceId = result.serverInstanceId

		if
			type(serverInstanceId) ~= "string"
			or not string.match(
				serverInstanceId,
				"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
			)
		then
			serverInstanceId = nil
		end
	end

	return {
		challengeId = challengeId,
		desiredPlaceId = desiredPlaceId,
		serverInstanceId = serverInstanceId
	}
end

return RoCaptchaUtils
