local url = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").Url

return function(callback)
	return callback(
		string.format("%s/v1/settings/record-user-seen-avatar-video-upsell-modal", url.VOICE_URL),
		"POST",
		{ postBody = "{}" }
	)
end
