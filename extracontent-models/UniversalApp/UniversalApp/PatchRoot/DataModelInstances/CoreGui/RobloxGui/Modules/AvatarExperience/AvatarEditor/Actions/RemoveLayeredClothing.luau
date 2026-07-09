local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(b1: boolean?) -- line: 9
	return {
		hasLayeredHair = b1
	}
end)
