local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 10
	return {
		userId = tostring(p1)
	}
end)
