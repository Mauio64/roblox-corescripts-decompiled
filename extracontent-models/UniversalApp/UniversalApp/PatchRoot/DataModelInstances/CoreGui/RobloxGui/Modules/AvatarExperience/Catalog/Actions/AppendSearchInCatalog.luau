local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 11
	return {
		searchUuid = p1,
		searchInCatalog = p2
	}
end)
