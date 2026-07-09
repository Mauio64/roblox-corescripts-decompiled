local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 12
	return {
		bundleId = p1,
		bundleInfo = p2
	}
end)
