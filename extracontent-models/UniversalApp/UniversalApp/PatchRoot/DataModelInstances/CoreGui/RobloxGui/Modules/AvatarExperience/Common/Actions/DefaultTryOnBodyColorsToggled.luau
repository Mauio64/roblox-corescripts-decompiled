local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(b1: boolean) -- line: 4
	return {
		state = b1
	}
end)
