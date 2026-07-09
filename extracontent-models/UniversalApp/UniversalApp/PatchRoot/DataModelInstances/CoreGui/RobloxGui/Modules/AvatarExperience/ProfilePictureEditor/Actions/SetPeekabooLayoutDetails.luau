local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2, p3, p4) -- line: 4
	return {
		screenName = p1,
		screenHeightPix = p2,
		topYPix = p3,
		viewportSizePix = p4
	}
end)
