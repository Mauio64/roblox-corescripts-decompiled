local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 11
	return {
		userId = tostring(p1),
		character = p2
	}
end)
