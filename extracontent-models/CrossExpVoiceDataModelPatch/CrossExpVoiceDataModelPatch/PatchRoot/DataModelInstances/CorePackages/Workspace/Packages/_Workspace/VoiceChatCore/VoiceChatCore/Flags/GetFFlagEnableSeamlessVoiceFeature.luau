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

local t1 = {
	[Constants.SeamlessVoiceFeatures.ConnectDisconnect] = function() -- line: 22
		return game:GetFastFlag("EnableConnectDisconnect")
	end,
	[Constants.SeamlessVoiceFeatures.HearingWithoutMicPermissions] = function() -- line: 25
		return game:GetFastFlag("EnableHearingWithoutMicPermissions")
	end,
	[Constants.SeamlessVoiceFeatures.JoinVoiceIsMutedMic] = function() -- line: 28
		return game:GetFastFlag("EnableJoinVoiceIsMutedMic")
	end,
	[Constants.SeamlessVoiceFeatures.JoinVoiceTooltip] = function() -- line: 31
		return game:GetFastFlag("EnableJoinVoiceTooltip")
	end,
	[Constants.SeamlessVoiceFeatures.InitialJoinVoice] = function() -- line: 34
		return game:GetFastFlag("EnableInitialJoinVoiceButton")
	end,
	[Constants.SeamlessVoiceFeatures.DeferConnection] = function() -- line: 37
		return game:GetFastFlag("EnableDeferVoiceConnection")
	end,
	[Constants.SeamlessVoiceFeatures.HideJoinToastSubtitle] = function() -- line: 40
		return game:GetFastFlag("EnableHideJoinToastSubtitle")
	end
}

return function(p1) -- line: 45
	-- upvalues: t1 (copy)
	if type(p1) == "string" then
		p1 = { p1 }
	end

	if p1 == nil or #p1 == 0 or not game:GetFastFlag("EnableSeamlessVoiceFeature") then
		return game:GetFastFlag("EnableSeamlessVoiceFeature")
	end

	for _, v in pairs(p1) do
		local v7 = t1[v]

		if not v7 or not v7() then
			return false
		end
	end

	return true
end
