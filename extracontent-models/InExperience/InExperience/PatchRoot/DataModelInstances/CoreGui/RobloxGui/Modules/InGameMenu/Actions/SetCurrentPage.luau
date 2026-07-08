local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_CURRENT_PAGE", function(p1) -- line: 5
	return {
		newPage = p1
	}
end)
