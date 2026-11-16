local SceneAnalysisContext = require(script.SceneAnalysisContext)
return {
	SceneAnalysisProvider = SceneAnalysisContext.Provider,
	useAssetsInView = require(script.useAssetsInView),
	useAssetsInRange = require(script.useAssetsInRange),
	useAudibleSounds = require(script.useAudibleSounds)
}
