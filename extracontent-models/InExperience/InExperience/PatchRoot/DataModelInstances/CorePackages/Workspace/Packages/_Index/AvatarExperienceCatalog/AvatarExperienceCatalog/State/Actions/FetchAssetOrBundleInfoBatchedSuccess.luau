local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(data)
	return {
		hydratedBundles = data.hydratedBundles,
		assetsInBundle = data.assetsInBundle,
		hydratedAssets = data.hydratedAssets
	}
end)
