game:DefineFastFlag("FixSeamlessVoiceIntegrationWithPrivateVoice2", false)

local GetFFlagEnableCrossExpVoice = require(script.Parent.GetFFlagEnableCrossExpVoice)

return function()
	return GetFFlagEnableCrossExpVoice() and game:GetFastFlag("FixSeamlessVoiceIntegrationWithPrivateVoice2")
end
