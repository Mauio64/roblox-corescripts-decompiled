local scriptParent = script.Parent

return {
	ProgressLoadingAssetsScreenGui = require(scriptParent.RoactUtils).Components.createLazyComponent(function() -- line: 5
		return require(script.ProgressLoadingAssetsScreenGui)
	end),
	GetDeferredAssetStore = require(script.Stores.GetDeferredAssetStore),
	["jest.config"] = script["jest.config"]
}
