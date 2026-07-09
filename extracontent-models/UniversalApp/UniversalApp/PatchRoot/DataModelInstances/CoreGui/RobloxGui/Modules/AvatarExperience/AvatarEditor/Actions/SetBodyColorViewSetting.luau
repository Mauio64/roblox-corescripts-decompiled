local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 9
	return {
		bodyColorViewSetting = s1
	}
end)
