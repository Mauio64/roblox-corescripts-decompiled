local VoiceChat = script:FindFirstAncestor("VoiceChat")
local SetVoiceChatOptInStatus = require(VoiceChat.OptInStatus.SetVoiceChatOptInStatus)
local VoiceChatParent = VoiceChat.Parent
local Cryo = require(VoiceChatParent.Cryo)

return function(p1, p2) -- line: 6
	-- upvalues: SetVoiceChatOptInStatus (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetVoiceChatOptInStatus.name then
		v7 = Cryo.Dictionary.join(v7, {
			isUserOptIn = p2.isUserOptIn
		})
	end

	return v7
end
