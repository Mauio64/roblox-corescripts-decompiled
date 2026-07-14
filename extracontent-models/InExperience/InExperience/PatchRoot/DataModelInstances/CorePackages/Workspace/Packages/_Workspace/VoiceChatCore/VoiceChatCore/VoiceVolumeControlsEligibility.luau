local VoiceChatService = game:GetService("VoiceChatService")
local EngineFeature = game:GetEngineFeature("VoiceVolumeControlsEnableCreatorVoiceVolumeOptOut")
local EngineFeature2 = game:GetEngineFeature("VoiceVolumeControlsCreatorVoiceVolumeOptOutDefaultBehaviorIsEnabled")

local function resolveEnableVoiceVolumeControls(p1) -- line: 10
	-- upvalues: EngineFeature2 (copy)
	if p1 == Enum.RolloutState.Enabled then
		return true
	end

	if p1 == Enum.RolloutState.Disabled then
		return false
	end

	return EngineFeature2
end

return {
	isCreatorVoiceVolumeControlsEnabled = function() -- line: 20
		-- upvalues: EngineFeature (copy), VoiceChatService (copy), EngineFeature2 (copy)
		if EngineFeature then
			local EnableVoiceVolumeControls = VoiceChatService.EnableVoiceVolumeControls

			if EnableVoiceVolumeControls == Enum.RolloutState.Enabled then
				return true
			end

			if EnableVoiceVolumeControls == Enum.RolloutState.Disabled then
				return false
			end

			return EngineFeature2
		end

		return true
	end,
	isVoiceChatVolumeSliderVisible = function(b1: boolean, b2: boolean) -- line: 28
		-- upvalues: EngineFeature (copy), VoiceChatService (copy), EngineFeature2 (copy)
		if b1 then
			b1 = b2

			if b1 then
				if EngineFeature then
					local EnableVoiceVolumeControls = VoiceChatService.EnableVoiceVolumeControls

					if EnableVoiceVolumeControls == Enum.RolloutState.Enabled then
						return true
					end

					if EnableVoiceVolumeControls == Enum.RolloutState.Disabled then
						return false
					end

					return EngineFeature2
				end

				b1 = true
			end
		end

		return b1
	end
}
