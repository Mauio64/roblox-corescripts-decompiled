local VoiceChatService = game:GetService("VoiceChatService")

local engineFeature = game:GetEngineFeature("VoiceVolumeControlsEnableCreatorVoiceVolumeOptOut")

local engineFeature2 = game:GetEngineFeature("VoiceVolumeControlsCreatorVoiceVolumeOptOutDefaultBehaviorIsEnabled")

local function resolveEnableVoiceVolumeControls(enableVoiceVolumeControls) -- 2 equivalent calls inferred from this helper
	if enableVoiceVolumeControls == Enum.RolloutState.Enabled then
		return true
	end

	return enableVoiceVolumeControls ~= Enum.RolloutState.Disabled and engineFeature2
end

local VoiceVolumeControlsEligibility = {}

function VoiceVolumeControlsEligibility.isCreatorVoiceVolumeControlsEnabled()
	if not engineFeature then
		return true
	end

	return resolveEnableVoiceVolumeControls(VoiceChatService.EnableVoiceVolumeControls) -- inferred equivalent call
end

function VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(flag: boolean, flag2: boolean)
	if not flag then
		flag2 = flag
		return flag2
	end

	if not flag2 then
		return flag2
	end

	if not engineFeature then
		flag2 = true
		return true
	end

	return resolveEnableVoiceVolumeControls(VoiceChatService.EnableVoiceVolumeControls) -- inferred equivalent call
end

return VoiceVolumeControlsEligibility
