local VoiceChat = script:FindFirstAncestor("VoiceChat")
local SetVoiceChatOptInStatus = require(VoiceChat.OptInStatus.SetVoiceChatOptInStatus)
local parent = VoiceChat.Parent
local Cryo = require(parent.Cryo)

return function(options, p)
	local joined = options or {}

	if p.type == SetVoiceChatOptInStatus.name then
		joined = Cryo.Dictionary.join(joined, { isUserOptIn = p.isUserOptIn })
	end

	return joined
end
