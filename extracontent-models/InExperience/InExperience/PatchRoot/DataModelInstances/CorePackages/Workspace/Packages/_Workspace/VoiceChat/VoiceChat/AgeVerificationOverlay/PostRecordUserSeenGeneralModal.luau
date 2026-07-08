local Parent = script:FindFirstAncestor("VoiceChat").Parent
local Url = require(Parent.Http).Url
local HttpService = game:GetService("HttpService")

return function(p1, p2) -- line: 11
	-- upvalues: HttpService (copy), Url (copy)
	assert(type(p2) == "string", "PostRecordUserSeenGeneralModal request expects modalId to be a string")

	local json = HttpService:JSONEncode({
		modalId = p2
	})

	return p1(string.format("%s/v1/settings/record-user-seen-modal", Url.VOICE_URL), "POST", json)
end
