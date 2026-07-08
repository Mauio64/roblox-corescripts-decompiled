local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 4
	return {
		itemId = p1,
		itemType = p2
	}
end)
