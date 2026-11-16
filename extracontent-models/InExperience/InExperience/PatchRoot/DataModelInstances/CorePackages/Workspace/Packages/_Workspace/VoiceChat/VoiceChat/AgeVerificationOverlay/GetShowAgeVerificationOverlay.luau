local parent = script:FindFirstAncestor("VoiceChat").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, value, value2)
	assert(type(value2) == "string", "GetShowAgeVerificationOverlay request expects placeId to be a string")
	assert(type(value) == "string", "GetShowAgeVerificationOverlay request expects universeId to be a string")

	local VOICE_URL = Url.VOICE_URL

	if value2 ~= "" and value2 ~= nil then
		value ..= "?placeId=" .. value2
	end

	return callback(string.format("%s/v1/settings/verify/show-age-verification-overlay/%s", VOICE_URL, value), "GET")
end
