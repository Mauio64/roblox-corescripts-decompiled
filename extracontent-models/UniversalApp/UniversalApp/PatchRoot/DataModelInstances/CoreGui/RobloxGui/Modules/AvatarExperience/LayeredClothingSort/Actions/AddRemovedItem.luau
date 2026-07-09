local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 12
	return {
		removedAssetId = p1,
		removedAssetTypeId = p2
	}
end)
