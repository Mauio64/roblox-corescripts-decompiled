local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 5
	return {
		promptType = p1,
		promptInfo = p2
	}
end)
