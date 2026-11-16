local VoiceChatCore = script:FindFirstAncestor("VoiceChatCore")
local Constants = require(VoiceChatCore.Constants)

local function createQueryParams(items)
	local v = ""
	local count = 0

	for k, item in items do
		v ..= (count > 0 and "&" or "") .. k .. "=" .. item
		count += 1
	end

	if count == 0 then
		return ""
	end

	return "?" .. v
end

return function(callback, value: string, placeId: string, flag: boolean?)
	assert(type(placeId) == "string", "GetShowAgeVerificationOverlay request expects placeId to be a string")
	assert(type(value) == "string", "GetShowAgeVerificationOverlay request expects universeId to be a string")
	assert(
		type(flag) == "boolean" or type(flag) == "nil",
		"GetShowAgeVerificationOverlay request expects hasMicPermissions to be a boolean or nil"
	)

	local v = {}

	if flag ~= nil then
		v.userHasDisabledMicDevicePermissions = tostring(not flag)
	end

	if placeId ~= "" and placeId ~= nil then
		v.placeId = placeId
	end

	return callback(
		string.format(
			"%s/v1/settings/verify/show-age-verification-overlay/%s%s",
			Constants.VOICE_URL,
			value,
			createQueryParams(v)
		),
		"GET"
	)
end
