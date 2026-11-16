local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/IxpServiceWrapper").IXPServiceWrapper
game:DefineFastFlag("BatchVoiceParticipantsUpdates", false)
local defineFastString = game:DefineFastString(
	"ThrottleVoiceParticipantsUpdateLayerName",
	"Voice.Performance"
)
local defineFastString2 = game:DefineFastString(
	"ThrottleVoiceParticipantsUpdateLayerValue",
	"BatchVoiceParticipantsUpdates"
)
local success, result

if game:GetFastFlag("BatchVoiceParticipantsUpdates") then
	success, result = pcall(function()
		return ixpServiceWrapper:GetLayerData(defineFastString)
	end)
else
	success = nil
	result = nil
end

return function()
	return game:GetFastFlag("BatchVoiceParticipantsUpdates")
		and success
		and result
		and result[defineFastString2]
end
