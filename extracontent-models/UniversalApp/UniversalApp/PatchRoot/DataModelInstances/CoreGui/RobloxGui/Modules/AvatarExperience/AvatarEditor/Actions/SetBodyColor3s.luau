local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		bodyColor3s = p1
	}
end)
