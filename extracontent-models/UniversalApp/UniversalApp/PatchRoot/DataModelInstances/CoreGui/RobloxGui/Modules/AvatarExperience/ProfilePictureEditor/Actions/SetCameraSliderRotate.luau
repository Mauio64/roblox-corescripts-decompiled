local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1) -- line: 4
	return {
		rotateSliderValue = p1
	}
end)
