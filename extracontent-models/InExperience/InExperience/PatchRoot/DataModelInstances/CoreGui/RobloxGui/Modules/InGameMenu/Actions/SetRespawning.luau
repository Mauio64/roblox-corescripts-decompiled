local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_RESPAWNING", function(p1) -- line: 5
	return {
		respawning = p1
	}
end)
