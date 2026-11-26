local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Constants")

local function createQueryParams(items)
	local v5 = ""
	local count = 0

	for k, item in items do
		v5 ..= (count > 0 and "&" or "") .. k .. "=" .. item
		count += 1
	end

	if count == 0 then
		return ""
	end

	return "?" .. v5
end

return function(callback, value, placeId, p2)
	assert(
		type(placeId) == "string",
		"GetShowAgeVerificationOverlay request expects placeId to be a string"
	)
	assert(
		type(value) == "string",
		"GetShowAgeVerificationOverlay request expects universeId to be a string"
	)
	assert(
		type(p2) == "boolean" or type(p2) == "nil",
		"GetShowAgeVerificationOverlay request expects hasMicPermissions to be a boolean or nil"
	)

	local v5 = {}

	if p2 ~= nil then
		v5.userHasDisabledMicDevicePermissions = tostring(not p2)
	end

	if placeId ~= "" and placeId ~= nil then
		v5.placeId = placeId
	end

	return callback(
		string.format(
			"%s/v1/settings/verify/show-age-verification-overlay/%s%s",
			Constants.VOICE_URL,
			value,
			createQueryParams(v5)
		),
		"GET"
	)
end
