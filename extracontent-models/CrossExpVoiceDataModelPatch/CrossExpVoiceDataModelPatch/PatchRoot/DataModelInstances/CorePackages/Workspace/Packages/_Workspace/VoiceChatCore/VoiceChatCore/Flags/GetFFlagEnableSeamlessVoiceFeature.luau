local VoiceChatCore = script:FindFirstAncestor("VoiceChatCore")
local Constants = require(VoiceChatCore.Constants)

game:DefineFastFlag("EnableSeamlessVoiceFeature", false)

game:DefineFastFlag("EnableConnectDisconnect", false)
game:DefineFastFlag("EnableHearingWithoutMicPermissions", false)
game:DefineFastFlag("EnableDeferVoiceConnection", false)

game:DefineFastFlag("EnableJoinVoiceIsMutedMic", false)
game:DefineFastFlag("EnableJoinVoiceTooltip", false)
game:DefineFastFlag("EnableInitialJoinVoiceButton", false)

game:DefineFastFlag("EnableHideJoinToastSubtitle", false)

local v = {
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
	local v2 = type(value) == "string" and { value } or value

	if v2 == nil or #v2 == 0 or not game:GetFastFlag("EnableSeamlessVoiceFeature") then
		return game:GetFastFlag("EnableSeamlessVoiceFeature")
	end

	for _, v3 in pairs(v2) do
		local v4 = v[v3]

		if not (v4 and v4()) then
			return false
		end
	end

	return true
end
