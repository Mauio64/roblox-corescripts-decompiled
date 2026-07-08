local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, s1: string?) -- line: 10
	return {
		textChatMessage = p1,
		channelNameOverride = s1
	}
end)
