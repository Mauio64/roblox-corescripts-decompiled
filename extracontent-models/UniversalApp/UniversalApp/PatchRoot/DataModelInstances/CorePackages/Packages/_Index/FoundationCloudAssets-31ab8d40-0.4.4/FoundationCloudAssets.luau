local script = script

local preloadAsset = require(script.preloadAsset)
return {
	Assets = require(script.Generated.ConsolidatedAssets),
	preloadAsset = preloadAsset
}
