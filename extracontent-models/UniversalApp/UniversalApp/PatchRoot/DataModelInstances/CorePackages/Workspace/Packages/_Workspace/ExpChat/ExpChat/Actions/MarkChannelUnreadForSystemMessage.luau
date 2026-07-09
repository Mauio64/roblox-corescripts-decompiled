local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, s2: string, s3: string?) -- line: 11
	return {
		text = s1,
		channelNameOverride = s2,
		metadata = s3
	}
end)
