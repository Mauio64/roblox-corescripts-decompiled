local VoiceChatCore = script:FindFirstAncestor("VoiceChatCore")
local Constants = require(VoiceChatCore.Constants)

local function createQueryParams(t1: {[any]: any}) -- line: 9
	local s1 = ""
	local n1 = 0

	for v7, v8 in t1 do
		s1 ..= (not (n1 > 0) and "" or "&") .. v7 .. "=" .. v8
		n1 += 1
	end

	if n1 == 0 then
		return ""
	end

	return "?" .. s1
end

return function(p1, s2: string, s3: string, b1: boolean?) -- line: 19
	-- upvalues: Constants (copy), createQueryParams (copy)
	assert(type(s3) == "string", "GetShowAgeVerificationOverlay request expects placeId to be a string")
	assert(type(s2) == "string", "GetShowAgeVerificationOverlay request expects universeId to be a string")
	assert(type(b1) == "boolean" or type(b1) == "nil", "GetShowAgeVerificationOverlay request expects hasMicPermissions to be a boolean or nil")

	local t2 = {}

	if b1 ~= nil then
		t2.userHasDisabledMicDevicePermissions = tostring(not b1)
	end

	if s3 ~= "" and s3 ~= nil then
		t2.placeId = s3
	end

	return p1(string.format("%s/v1/settings/verify/show-age-verification-overlay/%s%s", Constants.VOICE_URL, s2, (createQueryParams(t2))), "GET")
end
