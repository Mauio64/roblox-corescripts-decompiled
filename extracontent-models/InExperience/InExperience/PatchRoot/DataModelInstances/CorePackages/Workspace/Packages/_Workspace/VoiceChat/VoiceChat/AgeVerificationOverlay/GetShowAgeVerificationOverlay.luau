local Parent = script:FindFirstAncestor("VoiceChat").Parent
local Url = require(Parent.Http).Url

return function(p1, p2, p3) -- line: 10
	-- upvalues: Url (copy)
	assert(type(p3) == "string", "GetShowAgeVerificationOverlay request expects placeId to be a string")
	assert(type(p2) == "string", "GetShowAgeVerificationOverlay request expects universeId to be a string")

	return p1(string.format("%s/v1/settings/verify/show-age-verification-overlay/%s", Url.VOICE_URL, if p3 == "" or p3 == nil then p2 else p2 .. "?placeId=" .. p3), "GET")
end
