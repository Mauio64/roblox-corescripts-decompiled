local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 9
	return {
		textChannel = p1
	}
end)
