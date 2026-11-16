local parent = script:FindFirstAncestor("VoiceChat").Parent
local Http = require(parent.Http)
local Url = Http.Url
local HttpService = game:GetService("HttpService")

return function(callback, informedOfBan)
	assert(type(informedOfBan) == "boolean", "PostInformedOfBan request expects informedOfBan to be a boolean")

	return callback(
		string.format("%sv1/moderation/informed-of-ban", Url.VOICE_URL),
		"POST",
		(HttpService:JSONEncode({ informedOfBan = informedOfBan }))
	)
end
