local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 8
	return {
		reportCategory = p1,
		reportType = p2,
		annotationPoints = p3
	}
end)
