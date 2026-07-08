local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_RESPAWN_BEHAVIOR", function(p1, p2) -- line: 5
	return {
		respawnEnabled = p1,
		customCallback = p2
	}
end)
