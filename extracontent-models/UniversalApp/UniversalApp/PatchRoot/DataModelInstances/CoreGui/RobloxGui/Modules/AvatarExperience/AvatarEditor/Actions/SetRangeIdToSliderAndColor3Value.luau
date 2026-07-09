local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 11
	return {
		rangeId = p1,
		color3 = p2,
		sliderValue = p3
	}
end)
