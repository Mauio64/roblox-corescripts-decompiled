local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_CONTROL_LAYOUT", function(p1) -- line: 5
	return {
		controlLayout = p1
	}
end)
