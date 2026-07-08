local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_INPUT_TYPE", function(p1) -- line: 5
	return {
		inputType = p1
	}
end)
