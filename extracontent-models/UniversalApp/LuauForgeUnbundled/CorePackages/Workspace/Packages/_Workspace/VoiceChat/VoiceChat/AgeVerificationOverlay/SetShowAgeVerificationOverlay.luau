return require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Rodux").makeActionCreator(
	"SetShowAgeVerificationOverlay",
	function(p2, p3, p4, p5, p6, p7, p8)
		return {
			universeId = p2,
			isPlaceEnabledForVoice = p3,
			isUniverseEnabledForVoice = p4,
			isVoiceEnabled = p5,
			isUniverseEnabledForAvatarVideo = p7,
			showVoiceOptInOverlay = p6,
			elegibleToSeeVoiceUpsell = p8
		}
	end
)
