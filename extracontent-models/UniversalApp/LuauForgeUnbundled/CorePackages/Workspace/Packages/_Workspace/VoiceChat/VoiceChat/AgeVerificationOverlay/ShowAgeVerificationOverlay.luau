local SetShowAgeVerificationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChat/AgeVerificationOverlay/SetShowAgeVerificationOverlay")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/Cryo")

return function(options, data)
	local v5 = options or {}

	if data.type ~= SetShowAgeVerificationOverlay.name then
		return v5
	end

	local join = Cryo.Dictionary.join
	local v6

	if data.universeId == nil then
		v6 = {}
	else
		v6 = {
			[data.universeId] = {
				universeId = data.universeId,
				isPlaceEnabledForVoice = data.isPlaceEnabledForVoice,
				showVoiceOptInOverlay = data.showVoiceOptInOverlay,
				isUniverseEnabledForVoice = data.isUniverseEnabledForVoice,
				isVoiceEnabled = data.isVoiceEnabled,
				isUniverseEnabledForAvatarVideo = data.isUniverseEnabledForAvatarVideo,
				elegibleToSeeVoiceUpsell = data.elegibleToSeeVoiceUpsell
			}
		} or {}
	end

	v5 = join(v5, v6)

	return v5
end
