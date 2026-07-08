local _script = script
local preloadAsset = require(_script.preloadAsset)

return {
	Assets = require(_script.Generated.ConsolidatedAssets),
	preloadAsset = preloadAsset
}
