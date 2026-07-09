local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(n1: number, n2: number) -- line: 10
	return {
		assetTypeId = n1,
		assetId = n2
	}
end)
