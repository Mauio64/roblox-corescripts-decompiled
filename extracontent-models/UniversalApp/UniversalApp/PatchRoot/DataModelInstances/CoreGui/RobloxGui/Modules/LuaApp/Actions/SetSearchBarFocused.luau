local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SetSearchBarFocused", function(p1) -- line: 4
	return {
		focused = p1
	}
end)
