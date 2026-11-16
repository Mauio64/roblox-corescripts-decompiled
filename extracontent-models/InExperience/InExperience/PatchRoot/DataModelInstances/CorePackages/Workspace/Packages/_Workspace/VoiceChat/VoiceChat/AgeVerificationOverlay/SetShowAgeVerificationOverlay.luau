local parent = script:FindFirstAncestor("VoiceChat").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(
	script.Name,
	function(universeId, isPlaceEnabledForVoice, isUniverseEnabledForVoice, isVoiceEnabled, showVoiceOptInOverlay, isUniverseEnabledForAvatarVideo, elegibleToSeeVoiceUpsell)
		return {
			universeId = universeId,
			isPlaceEnabledForVoice = isPlaceEnabledForVoice,
			isUniverseEnabledForVoice = isUniverseEnabledForVoice,
			isVoiceEnabled = isVoiceEnabled,
			isUniverseEnabledForAvatarVideo = isUniverseEnabledForAvatarVideo,
			showVoiceOptInOverlay = showVoiceOptInOverlay,
			elegibleToSeeVoiceUpsell = elegibleToSeeVoiceUpsell
		}
	end
)
