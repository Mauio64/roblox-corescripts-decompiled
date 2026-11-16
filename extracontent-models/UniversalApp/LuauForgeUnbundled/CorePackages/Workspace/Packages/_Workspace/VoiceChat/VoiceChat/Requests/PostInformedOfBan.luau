local url = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").Url
local HttpService = game:GetService("HttpService")

return function(callback, p2)
	assert(type(p2) == "boolean", "PostInformedOfBan request expects informedOfBan to be a boolean")

	return callback(
		string.format("%sv1/moderation/informed-of-ban", url.VOICE_URL),
		"POST",
		(HttpService:JSONEncode({ informedOfBan = p2 }))
	)
end
