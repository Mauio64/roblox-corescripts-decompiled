local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3, p4) -- line: 6
	return {
		conversationId = p1,
		participants = p2,
		title = p3,
		lastUpdated = p4
	}
end)
