local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string) -- line: 11
	return {
		messageId = s1,
		newText = s2
	}
end)
