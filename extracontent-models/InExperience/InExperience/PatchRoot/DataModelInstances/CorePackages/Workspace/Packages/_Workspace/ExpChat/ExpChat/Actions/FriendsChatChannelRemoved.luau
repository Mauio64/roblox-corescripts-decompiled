local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 9
	return {
		channelName = s1
	}
end)
