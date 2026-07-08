local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 10
	return {
		shareInviteLink = s1
	}
end)
