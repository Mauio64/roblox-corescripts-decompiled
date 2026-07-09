local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 16
	return {
		hydratedBundles = t1.hydratedBundles,
		assetsInBundle = t1.assetsInBundle,
		hydratedAssets = t1.hydratedAssets
	}
end)
