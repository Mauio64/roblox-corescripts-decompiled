local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 12
	return {
		searchUuid = p1,
		status = p2
	}
end)
