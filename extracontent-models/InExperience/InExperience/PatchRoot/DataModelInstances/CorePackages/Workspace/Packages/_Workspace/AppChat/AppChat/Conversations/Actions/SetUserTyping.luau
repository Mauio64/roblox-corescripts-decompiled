local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 5
	return {
		conversationId = p1,
		userId = p2,
		value = p3
	}
end)
