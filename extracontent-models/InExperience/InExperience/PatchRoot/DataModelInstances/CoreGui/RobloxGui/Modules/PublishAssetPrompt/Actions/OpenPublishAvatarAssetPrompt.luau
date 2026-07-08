local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string, p1, s2: string, p2) -- line: 22
	return {
		promptInfo = {
			promptType = s1,
			accessoryType = p1,
			guid = s2,
			scopes = p2
		}
	}
end)
