local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_FRIEND_STATUS", function(p1, p2) -- line: 5
	return {
		userId = p1,
		friendStatus = p2
	}
end)
