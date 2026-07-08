local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, p1) -- line: 11
	return {
		channelName = s1,
		textChannel = p1
	}
end)
