local parent = script:FindFirstAncestor("VoiceChat").Parent
local Http = require(parent.Http)
local Url = Http.Url
local HttpService = game:GetService("HttpService")

return function(callback, modalId)
	assert(type(modalId) == "string", "PostRecordUserSeenGeneralModal request expects modalId to be a string")

	local jsonEncode = HttpService:JSONEncode({ modalId = modalId })

	return callback(string.format("%s/v1/settings/record-user-seen-modal", Url.VOICE_URL), "POST", jsonEncode)
end
