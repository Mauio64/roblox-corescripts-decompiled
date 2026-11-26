local defineFastFlag = game:DefineFastFlag("AXProfileConfigurationMultiFieldApply", false)

local engineFeature = game:GetEngineFeature("AvatarEditorServiceApplyProfileConfigurationEnabled")
	and game:GetEngineFeature("FrameAssetInProfileConfigurationEnabled")

return defineFastFlag and engineFeature
