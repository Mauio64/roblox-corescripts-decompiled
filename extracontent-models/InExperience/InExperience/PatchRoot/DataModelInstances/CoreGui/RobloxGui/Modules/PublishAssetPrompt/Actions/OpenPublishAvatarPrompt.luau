local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string, p1) -- line: 19
	return {
		promptInfo = {
			promptType = s1,
			guid = s2,
			scopes = p1
		}
	}
end)
