local ViewportQueryOptions = require(script.options.ViewportQueryOptions)
local RangeQueryOptions = require(script.options.RangeQueryOptions)
local DataModelTraversalOptions = require(script.options.DataModelTraversalOptions)

return {
	ViewportQueryOptions = ViewportQueryOptions,
	RangeQueryOptions = RangeQueryOptions,
	DataModelTraversalOptions = DataModelTraversalOptions,
	getSourceAssetsInView = require(script.getSourceAssetsInView),
	getSourceAssetsInRange = require(script.getSourceAssetsInRange),
	createLazyInstanceCollector = require(script.traversal.createLazyInstanceCollector),
	isSourceAsset = require(script.isSourceAsset),
	calculatePotentialAudibility = require(script.audio.calculatePotentialAudibility),
	getAudibleVolume = require(script.audio.getAudibleVolume),
	isAudible = require(script.audio.isAudible)
}
