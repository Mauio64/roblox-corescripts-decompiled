local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3, p4, p5) -- line: 6
	return {
		minimumDeltaEBodyColorDifference = p1,
		scalesRules = p2,
		accessoryRefinementTypes = p3,
		accessoryRefinementLowerBounds = p4,
		accessoryRefinementUpperBounds = p5
	}
end)
