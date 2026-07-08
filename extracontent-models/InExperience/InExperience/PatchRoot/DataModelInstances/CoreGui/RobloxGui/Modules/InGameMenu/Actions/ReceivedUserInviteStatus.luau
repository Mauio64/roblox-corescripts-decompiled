local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("RECEIVED_USER_INVITE_STATUS", function(p1, p2) -- line: 5
	return {
		userId = tostring(p1),
		inviteStatus = p2
	}
end)
