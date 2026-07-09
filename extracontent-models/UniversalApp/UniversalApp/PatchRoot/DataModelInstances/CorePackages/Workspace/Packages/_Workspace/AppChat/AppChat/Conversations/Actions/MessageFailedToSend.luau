local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 6
	return {
		conversationId = p1,
		messageId = p2
	}
end)
