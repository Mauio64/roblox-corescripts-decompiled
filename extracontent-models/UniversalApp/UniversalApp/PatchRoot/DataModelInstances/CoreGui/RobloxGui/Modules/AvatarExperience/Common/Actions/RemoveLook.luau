local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 13
	return {
		lookId = s1
	}
end)
