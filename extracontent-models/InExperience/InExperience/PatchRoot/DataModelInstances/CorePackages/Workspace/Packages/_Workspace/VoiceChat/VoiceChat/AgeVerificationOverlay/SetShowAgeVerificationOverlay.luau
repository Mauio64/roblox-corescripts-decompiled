local Parent = script:FindFirstAncestor("VoiceChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3, p4, p5, p6, p7) -- line: 7
	return {
		universeId = p1,
		isPlaceEnabledForVoice = p2,
		isUniverseEnabledForVoice = p3,
		isVoiceEnabled = p4,
		isUniverseEnabledForAvatarVideo = p6,
		showVoiceOptInOverlay = p5,
		elegibleToSeeVoiceUpsell = p7
	}
end)
