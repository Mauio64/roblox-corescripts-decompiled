local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_SCREEN_SIZE", function(p1) -- line: 5
	return {
		newScreenSize = p1
	}
end)
