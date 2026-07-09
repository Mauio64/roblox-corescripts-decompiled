local GetFFlagEnableCrossExpVoice = require(script.Parent.GetFFlagEnableCrossExpVoice)

return function() -- line: 3
	-- upvalues: GetFFlagEnableCrossExpVoice (copy)
	return GetFFlagEnableCrossExpVoice() and game:GetEngineFeature("CrossExperienceVoiceMuteAll")
end
