local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 4
	return {
		searchUuid = p1,
		keyword = p2
	}
end)
