local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string, p1, p2, s2: string, p3) -- line: 23
	return {
		promptInfo = {
			promptType = s1,
			assetInstance = p1,
			assetType = p2,
			guid = s2,
			scopes = p3
		}
	}
end)
