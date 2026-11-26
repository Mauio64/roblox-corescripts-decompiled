local url = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").Url

return function(callback)
	return callback(string.format("%s/v1/settings/", url.VOICE_URL), "GET")
end
