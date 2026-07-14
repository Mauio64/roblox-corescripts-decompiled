local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(b1: boolean?) -- line: 10
	return {
		isGlobalTabActive = b1
	}
end)
