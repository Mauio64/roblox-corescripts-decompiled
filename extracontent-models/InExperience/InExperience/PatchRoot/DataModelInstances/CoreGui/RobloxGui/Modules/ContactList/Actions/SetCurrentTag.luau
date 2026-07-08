local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 5
	return {
		tag = s1
	}
end)
