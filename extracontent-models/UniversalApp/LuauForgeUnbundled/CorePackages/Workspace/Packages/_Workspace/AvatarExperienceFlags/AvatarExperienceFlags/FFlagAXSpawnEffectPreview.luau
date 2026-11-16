local engineFeature = game:GetEngineFeature("PlayAvatarEffectAsyncEnabled")
return game:DefineFastFlag("AXSpawnEffectPreview", false) and engineFeature
