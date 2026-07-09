local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 10
	return {
		character = p1
	}
end)
