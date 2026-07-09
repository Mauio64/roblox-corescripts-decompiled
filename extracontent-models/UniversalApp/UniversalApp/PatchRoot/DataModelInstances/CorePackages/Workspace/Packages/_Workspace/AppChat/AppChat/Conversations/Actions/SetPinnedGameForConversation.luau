local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 6
	return {
		universeId = p1,
		rootPlaceId = p2,
		conversationId = p3
	}
end)
