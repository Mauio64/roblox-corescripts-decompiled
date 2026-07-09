local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string) -- line: 13
	return {
		searchUuid = s1,
		status = s2
	}
end)
