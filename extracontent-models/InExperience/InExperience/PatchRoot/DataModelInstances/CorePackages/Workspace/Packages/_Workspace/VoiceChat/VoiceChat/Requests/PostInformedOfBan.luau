local Parent = script:FindFirstAncestor("VoiceChat").Parent
local Url = require(Parent.Http).Url
local HttpService = game:GetService("HttpService")

return function(p1, p2) -- line: 11
	-- upvalues: Url (copy), HttpService (copy)
	assert(type(p2) == "boolean", "PostInformedOfBan request expects informedOfBan to be a boolean")

	return p1(string.format("%sv1/moderation/informed-of-ban", Url.VOICE_URL), "POST", (HttpService:JSONEncode({
		informedOfBan = p2
	})))
end
