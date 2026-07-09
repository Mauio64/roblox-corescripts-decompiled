local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 5
	return {
		avatarScreen = p1,
		fullViewStatus = p2
	}
end)
