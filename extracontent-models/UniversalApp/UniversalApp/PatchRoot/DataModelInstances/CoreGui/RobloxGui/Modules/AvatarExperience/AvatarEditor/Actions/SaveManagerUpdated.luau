local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1) -- line: 4
	return {
		type = script.Name,
		character = p1
	}
end)
