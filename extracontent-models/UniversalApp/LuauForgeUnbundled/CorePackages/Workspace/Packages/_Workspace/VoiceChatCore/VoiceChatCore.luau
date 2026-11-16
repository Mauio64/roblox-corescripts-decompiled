local module = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/CoreVoiceManager")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/MicInputManager")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Analytics")
return {
	CoreVoiceManager = module,
	MicInputManager = module2,
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Constants"),
	Analytics = module3,
	VoiceVolumeControlsEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/VoiceVolumeControlsEligibility"),
	Flags = {
		GetFFlagVoiceChatServiceManagerUseAvatarChat = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagVoiceChatServiceManagerUseAvatarChat"),
		GetFFlagBatchVoiceParticipantsUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagBatchVoiceParticipantsUpdates"),
		GetFIntThrottleParticipantsUpdateMs = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFIntThrottleParticipantsUpdateMs"),
		GetFFlagEnableFtuxExitOnMuteToggle = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagEnableFtuxExitOnMuteToggle"),
		GetFFlagEnableSeamlessVoiceFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagEnableSeamlessVoiceFeature"),
		GetFFlagFixGetPlayerByUserIdStringCast = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagFixGetPlayerByUserIdStringCast"),
		GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry"),
		GetFFlagMicConsumerRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagMicConsumerRegistry")
	},
	Requests = { GetShowAgeVerificationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Requests/GetShowAgeVerificationOverlay") }
}
