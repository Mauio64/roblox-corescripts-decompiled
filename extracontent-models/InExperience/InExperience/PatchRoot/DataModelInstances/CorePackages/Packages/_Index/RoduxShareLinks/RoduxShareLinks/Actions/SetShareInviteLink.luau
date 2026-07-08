local Parent = script:FindFirstAncestor("RoduxShareLinks").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 9
	return {
		shareInviteLink = s1
	}
end)
