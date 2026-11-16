local url = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Http").Url
local HttpService = game:GetService("HttpService")

return function(callback, value)
	assert(type(value) == "string", "PostRecordUserSeenGeneralModal request expects modalId to be a string")

	local jsonEncode = HttpService:JSONEncode({ modalId = value })

	return callback(
		string.format("%s/v1/settings/record-user-seen-modal", url.VOICE_URL),
		"POST",
		jsonEncode
	)
end
