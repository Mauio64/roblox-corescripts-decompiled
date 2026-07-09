local TagAnnotationContext = require(script.TagAnnotationContext)

return {
	Provider = TagAnnotationContext.TagAnnotationProvider,
	useContext = TagAnnotationContext.useTagAnnotationContext,
	Overlay = require(script.TagAnnotationOverlay),
	useTagScanner = require(script.useTagScanner)
}
