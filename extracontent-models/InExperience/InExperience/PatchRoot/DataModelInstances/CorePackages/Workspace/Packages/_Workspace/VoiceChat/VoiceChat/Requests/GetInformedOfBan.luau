local Parent = script:FindFirstAncestor("VoiceChat").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 10
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/moderation/informed-of-ban", Url.VOICE_URL), "GET")
end
