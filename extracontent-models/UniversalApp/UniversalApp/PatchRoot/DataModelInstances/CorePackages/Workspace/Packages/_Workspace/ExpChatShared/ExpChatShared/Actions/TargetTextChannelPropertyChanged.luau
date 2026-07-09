local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, b1: boolean) -- line: 11
	return {
		textChannel = p1,
		shouldReorderTabs = b1
	}
end)
