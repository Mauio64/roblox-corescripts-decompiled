local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 10
	return {
		channelName = s1
	}
end)
