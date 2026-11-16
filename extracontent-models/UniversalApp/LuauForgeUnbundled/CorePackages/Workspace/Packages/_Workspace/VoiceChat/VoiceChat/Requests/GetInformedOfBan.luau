local url = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").Url

return function(callback)
	return callback(string.format("%sv1/moderation/informed-of-ban", url.VOICE_URL), "GET")
end
