local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 10
	return {
		conversationId = s1
	}
end)
