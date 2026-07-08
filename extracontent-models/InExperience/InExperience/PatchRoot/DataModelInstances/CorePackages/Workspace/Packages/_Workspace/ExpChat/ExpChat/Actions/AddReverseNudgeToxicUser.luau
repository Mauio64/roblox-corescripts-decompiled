local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, s1: string) -- line: 11
	return {
		toxicUserId = tostring(p1),
		reverseNudgeType = s1
	}
end)
