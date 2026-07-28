game:SetFlagVersion("VoiceVolumeControlsPerUserPlayerListButton", 2)

return game:DefineFastFlag("VoiceVolumeControlsPerUserPlayerListButton", false) and (game:GetEngineFeature("VoiceVolumeControlsApplyPerUserMultiplier") and game:GetEngineFeature("CoreUiDragDetectorWorksWhileMenuOpen"))
