local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string, p1, p2) -- line: 20
	return {
		promptInfo = {
			promptType = s1,
			guid = s2,
			scopes = p1,
			makeupEntries = p2
		}
	}
end)
