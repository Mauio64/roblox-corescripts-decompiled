local VoiceChat = script:FindFirstAncestor("VoiceChat")
local SetShowAgeVerificationOverlay = require(VoiceChat.AgeVerificationOverlay.SetShowAgeVerificationOverlay)
local VoiceChatParent = VoiceChat.Parent
local Cryo = require(VoiceChatParent.Cryo)

return function(p1, p2) -- line: 6
	-- upvalues: SetShowAgeVerificationOverlay (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetShowAgeVerificationOverlay.name then
		v7 = Cryo.Dictionary.join(v7, p2.universeId ~= nil and {
			[p2.universeId] = {
				universeId = p2.universeId,
				isPlaceEnabledForVoice = p2.isPlaceEnabledForVoice,
				showVoiceOptInOverlay = p2.showVoiceOptInOverlay,
				isUniverseEnabledForVoice = p2.isUniverseEnabledForVoice,
				isVoiceEnabled = p2.isVoiceEnabled,
				isUniverseEnabledForAvatarVideo = p2.isUniverseEnabledForAvatarVideo,
				elegibleToSeeVoiceUpsell = p2.elegibleToSeeVoiceUpsell
			}
		} or {})
	end

	return v7
end
