local CoreVoiceManager = require(script.CoreVoiceManager)
local Analytics = require(script.Analytics)
local Constants = require(script.Constants)
local Requests = script.Requests
local Flags = script.Flags

return {
	CoreVoiceManager = CoreVoiceManager,
	Constants = Constants,
	Analytics = Analytics,
	Flags = {
		GetFFlagUpdateDeviceInputPlayerChanged = require(Flags.GetFFlagUpdateDeviceInputPlayerChanged),
		GetFFlagVoiceChatServiceManagerUseAvatarChat = require(Flags.GetFFlagVoiceChatServiceManagerUseAvatarChat),
		GetFFlagBatchVoiceParticipantsUpdates = require(Flags.GetFFlagBatchVoiceParticipantsUpdates),
		GetFIntThrottleParticipantsUpdateMs = require(Flags.GetFIntThrottleParticipantsUpdateMs),
		GetFFlagEnableFtuxExitOnMuteToggle = require(Flags.GetFFlagEnableFtuxExitOnMuteToggle),
		GetFFlagEnableExpJoinMicPermAnalytics = require(Flags.GetFFlagEnableExpJoinMicPermAnalytics),
		GetFFlagEnableSeamlessVoiceFeature = require(Flags.GetFFlagEnableSeamlessVoiceFeature),
		GetFFlagFixGetPlayerByUserIdStringCast = require(Flags.GetFFlagFixGetPlayerByUserIdStringCast)
	},
	Requests = {
		GetShowAgeVerificationOverlay = require(Requests.GetShowAgeVerificationOverlay)
	},
	["jest.config"] = script["jest.config"]
}
