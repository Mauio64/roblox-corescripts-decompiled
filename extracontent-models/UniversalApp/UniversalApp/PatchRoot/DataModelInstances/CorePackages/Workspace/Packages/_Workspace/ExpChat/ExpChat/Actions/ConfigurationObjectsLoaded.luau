local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 13
	return {
		bubbleChatSettings = p1.bubbleChatSettings or {},
		chatWindowSettings = p1.chatWindowSettings or {},
		chatInputBarSettings = p1.chatInputBarSettings or {},
		channelTabsSettings = p1.channelTabsSettings or {}
	}
end)
