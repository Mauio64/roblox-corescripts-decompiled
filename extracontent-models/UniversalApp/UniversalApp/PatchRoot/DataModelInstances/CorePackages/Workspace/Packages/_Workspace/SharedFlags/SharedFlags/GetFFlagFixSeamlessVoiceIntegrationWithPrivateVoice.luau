game:DefineFastFlag("FixSeamlessVoiceIntegrationWithPrivateVoice2", false)

local GetFFlagEnableCrossExpVoice = require(script.Parent.GetFFlagEnableCrossExpVoice)

return function() -- line: 5
	-- upvalues: GetFFlagEnableCrossExpVoice (copy)
	return GetFFlagEnableCrossExpVoice() and game:GetFastFlag("FixSeamlessVoiceIntegrationWithPrivateVoice2")
end
