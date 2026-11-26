local VoiceChatService = game:GetService("VoiceChatService")

local engineFeature = game:GetEngineFeature("VoiceVolumeControlsEnableCreatorVoiceVolumeOptOut")

local engineFeature2 = game:GetEngineFeature("VoiceVolumeControlsCreatorVoiceVolumeOptOutDefaultBehaviorIsEnabled")

local function resolveEnableVoiceVolumeControls(p2)
	if p2 == Enum.RolloutState.Enabled then
		return true
	end

	if p2 == Enum.RolloutState.Disabled then
		return false
	end

	return engineFeature2
end

return {
	isCreatorVoiceVolumeControlsEnabled = function()
		if not engineFeature then
			return true
		end

		local enableVoiceVolumeControls = VoiceChatService.EnableVoiceVolumeControls

		if enableVoiceVolumeControls == Enum.RolloutState.Enabled then
			return true
		end

		if enableVoiceVolumeControls == Enum.RolloutState.Disabled then
			return false
		end

		return engineFeature2
	end,
	isVoiceChatVolumeSliderVisible = function(p2, p3)
		if not p2 then
			p3 = p2
			return p3
		end

		if not p3 then
			return p3
		end

		if not engineFeature then
			p3 = true
			return true
		end

		local enableVoiceVolumeControls = VoiceChatService.EnableVoiceVolumeControls

		if enableVoiceVolumeControls == Enum.RolloutState.Enabled then
			return true
		end

		if enableVoiceVolumeControls == Enum.RolloutState.Disabled then
			return false
		end

		return engineFeature2
	end
}
