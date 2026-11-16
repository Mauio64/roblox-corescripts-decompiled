local CoreVoiceManager = require(script.CoreVoiceManager)
local MicInputManager = require(script.MicInputManager)
local Analytics = require(script.Analytics)
local Constants = require(script.Constants)
local VoiceVolumeControlsEligibility = require(script.VoiceVolumeControlsEligibility)
local Requests = script.Requests
local Flags = script.Flags

return {
	CoreVoiceManager = CoreVoiceManager,
	MicInputManager = MicInputManager,
	Constants = Constants,
	Analytics = Analytics,
	VoiceVolumeControlsEligibility = VoiceVolumeControlsEligibility,
	Flags = {
		GetFFlagVoiceChatServiceManagerUseAvatarChat = require(Flags.GetFFlagVoiceChatServiceManagerUseAvatarChat),
		GetFFlagBatchVoiceParticipantsUpdates = require(Flags.GetFFlagBatchVoiceParticipantsUpdates),
		GetFIntThrottleParticipantsUpdateMs = require(Flags.GetFIntThrottleParticipantsUpdateMs),
		GetFFlagEnableFtuxExitOnMuteToggle = require(Flags.GetFFlagEnableFtuxExitOnMuteToggle),
		GetFFlagEnableSeamlessVoiceFeature = require(Flags.GetFFlagEnableSeamlessVoiceFeature),
		GetFFlagFixGetPlayerByUserIdStringCast = require(Flags.GetFFlagFixGetPlayerByUserIdStringCast),
		GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry = require(Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry),
		GetFFlagMicConsumerRegistry = require(Flags.GetFFlagMicConsumerRegistry)
	},
	Requests = {
		GetShowAgeVerificationOverlay = require(Requests.GetShowAgeVerificationOverlay)
	},
	["jest.config"] = script["jest.config"]
}
