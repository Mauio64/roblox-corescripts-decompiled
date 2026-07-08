local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 4
	return {
		tryingOn = p1,
		assetId = p2,
		assetTypeId = p3
	}
end)
