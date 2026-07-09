local CorePackages = game:GetService("CorePackages")

return (require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string?) -- line: 18
	return {
		creatorFilter = s1 or ""
	}
end))
