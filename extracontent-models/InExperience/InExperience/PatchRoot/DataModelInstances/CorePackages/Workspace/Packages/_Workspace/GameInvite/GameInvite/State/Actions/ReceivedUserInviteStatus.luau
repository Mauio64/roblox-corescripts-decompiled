local Parent = script:FindFirstAncestor("GameInvite").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 6
	return {
		userId = tostring(p1),
		inviteStatus = p2
	}
end)
