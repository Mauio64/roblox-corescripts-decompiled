local FFlagEditProfileImageV2Enabled = require(script.Parent.FFlagEditProfileImageV2Enabled)

return game:DefineFastFlag("EditProfileFramesEnabled2", false)
	and FFlagEditProfileImageV2Enabled
	and game:GetEngineFeature("FrameAssetInProfileConfigurationEnabled")
