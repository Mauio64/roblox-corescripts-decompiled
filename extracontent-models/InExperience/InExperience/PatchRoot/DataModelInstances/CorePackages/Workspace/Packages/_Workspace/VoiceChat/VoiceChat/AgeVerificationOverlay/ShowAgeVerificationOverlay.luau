local VoiceChat = script:FindFirstAncestor("VoiceChat")
local SetShowAgeVerificationOverlay = require(VoiceChat.AgeVerificationOverlay.SetShowAgeVerificationOverlay)
local parent = VoiceChat.Parent
local Cryo = require(parent.Cryo)

return function(options, data)
	local v = options or {}

	if data.type ~= SetShowAgeVerificationOverlay.name then
		return v
	end

	local join = Cryo.Dictionary.join
	local v2

	if data.universeId == nil then
		v2 = {}
	else
		v2 = {
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

	return (join(v, v2))
end
