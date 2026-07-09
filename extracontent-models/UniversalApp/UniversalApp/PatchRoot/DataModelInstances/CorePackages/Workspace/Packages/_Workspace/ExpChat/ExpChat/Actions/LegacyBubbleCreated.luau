local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 10
	return {
		messageData = p1
	}
end)
