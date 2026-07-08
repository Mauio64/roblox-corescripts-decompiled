local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 5
	return {
		reportType = p1,
		targetPlayer = p2,
		onGoBack = p3
	}
end)
