local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 10
	return {
		items = p1,
		itemTypeId = p2,
		recommendationsType = p3
	}
end)
