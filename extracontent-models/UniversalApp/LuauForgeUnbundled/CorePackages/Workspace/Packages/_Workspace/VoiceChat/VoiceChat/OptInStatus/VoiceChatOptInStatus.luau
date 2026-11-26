local SetVoiceChatOptInStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/OptInStatus/SetVoiceChatOptInStatus")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Cryo")

return function(options, p2)
	local joined = options or {}

	if p2.type == SetVoiceChatOptInStatus.name then
		joined = Cryo.Dictionary.join(joined, { isUserOptIn = p2.isUserOptIn })
	end

	return joined
end
