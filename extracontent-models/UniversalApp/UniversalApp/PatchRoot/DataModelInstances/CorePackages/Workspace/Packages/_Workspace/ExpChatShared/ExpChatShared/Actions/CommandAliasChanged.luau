local Parent = script:FindFirstAncestor("ExpChatShared").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string, s3: string) -- line: 12
	return {
		name = s1,
		primaryAlias = s2,
		secondaryAlias = s3
	}
end)
