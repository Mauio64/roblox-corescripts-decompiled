local Parent = script:FindFirstAncestor("VoiceChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		isUserOptIn = p1
	}
end)
