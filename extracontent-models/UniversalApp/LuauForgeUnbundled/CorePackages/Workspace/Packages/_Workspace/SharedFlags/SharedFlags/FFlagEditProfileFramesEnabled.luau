local FFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEditProfileImageV2Enabled")

return game:DefineFastFlag("EditProfileFramesEnabled2", false)
	and FFlagEditProfileImageV2Enabled
	and game:GetEngineFeature("FrameAssetInProfileConfigurationEnabled")
