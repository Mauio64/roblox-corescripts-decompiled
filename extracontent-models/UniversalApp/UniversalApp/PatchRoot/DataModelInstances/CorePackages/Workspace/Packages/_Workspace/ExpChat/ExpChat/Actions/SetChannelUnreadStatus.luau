local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, b1: boolean) -- line: 10
	return {
		channelName = s1,
		hasUnreadMessages = b1
	}
end)
