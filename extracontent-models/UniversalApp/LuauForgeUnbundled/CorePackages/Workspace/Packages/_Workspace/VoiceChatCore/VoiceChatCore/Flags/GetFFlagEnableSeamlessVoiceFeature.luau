local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Constants")

game:DefineFastFlag("EnableSeamlessVoiceFeature", false)

game:DefineFastFlag("EnableConnectDisconnect", false)
game:DefineFastFlag("EnableHearingWithoutMicPermissions", false)
game:DefineFastFlag("EnableDeferVoiceConnection", false)

game:DefineFastFlag("EnableJoinVoiceIsMutedMic", false)
game:DefineFastFlag("EnableJoinVoiceTooltip", false)
game:DefineFastFlag("EnableInitialJoinVoiceButton", false)

game:DefineFastFlag("EnableHideJoinToastSubtitle", false)

local v5 = {
	[Constants.SeamlessVoiceFeatures.ConnectDisconnect] = function()
		return game:GetFastFlag("EnableConnectDisconnect")
	end,
	[Constants.SeamlessVoiceFeatures.HearingWithoutMicPermissions] = function()
		return game:GetFastFlag("EnableHearingWithoutMicPermissions")
	end,
	[Constants.SeamlessVoiceFeatures.JoinVoiceIsMutedMic] = function()
		return game:GetFastFlag("EnableJoinVoiceIsMutedMic")
	end,
	[Constants.SeamlessVoiceFeatures.JoinVoiceTooltip] = function()
		return game:GetFastFlag("EnableJoinVoiceTooltip")
	end,
	[Constants.SeamlessVoiceFeatures.InitialJoinVoice] = function()
		return game:GetFastFlag("EnableInitialJoinVoiceButton")
	end,
	[Constants.SeamlessVoiceFeatures.DeferConnection] = function()
		return game:GetFastFlag("EnableDeferVoiceConnection")
	end,
	[Constants.SeamlessVoiceFeatures.HideJoinToastSubtitle] = function()
		return game:GetFastFlag("EnableHideJoinToastSubtitle")
	end
}

return function(value)
	local v6 = type(value) == "string" and { value } or value

	if v6 == nil or #v6 == 0 or not game:GetFastFlag("EnableSeamlessVoiceFeature") then
		return game:GetFastFlag("EnableSeamlessVoiceFeature")
	end

	for k, v7 in pairs(v6) do
		local v8 = v5[v7]

		if not (v8 and v8()) then
			return false
		end
	end

	return true
end
