local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1) -- line: 7
	return {
		adjustableTryOnIds = p1
	}
end)
