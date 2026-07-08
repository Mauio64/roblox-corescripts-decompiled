local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 5
	return {
		title = p1,
		bodyText = p2,
		dismissCallback = p3
	}
end)
