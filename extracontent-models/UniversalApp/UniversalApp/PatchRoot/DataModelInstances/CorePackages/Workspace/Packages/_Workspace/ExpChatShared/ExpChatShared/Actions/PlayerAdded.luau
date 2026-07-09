local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, s1: string, s2: string, b1: boolean?) -- line: 15
	return {
		userId = tostring(p1),
		username = s1,
		displayName = s2,
		hasVerifiedBadge = b1
	}
end)
