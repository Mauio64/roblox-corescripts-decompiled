local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1) -- line: 8
	return {
		selectedSlot = p1
	}
end)
