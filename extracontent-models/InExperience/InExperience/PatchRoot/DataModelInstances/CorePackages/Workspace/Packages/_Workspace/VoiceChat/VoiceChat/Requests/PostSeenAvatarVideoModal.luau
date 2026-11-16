local parent = script:FindFirstAncestor("VoiceChat").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback)
	return callback(string.format("%s/v1/settings/record-user-seen-avatar-video-upsell-modal", Url.VOICE_URL), "POST", {
		postBody = "{}"
	})
end
