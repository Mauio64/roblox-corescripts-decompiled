return require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Rodux").makeActionCreator("FetchAssetOrBundleInfoBatchedSuccess", function(data)
	return {
		hydratedBundles = data.hydratedBundles,
		assetsInBundle = data.assetsInBundle,
		hydratedAssets = data.hydratedAssets
	}
end)
