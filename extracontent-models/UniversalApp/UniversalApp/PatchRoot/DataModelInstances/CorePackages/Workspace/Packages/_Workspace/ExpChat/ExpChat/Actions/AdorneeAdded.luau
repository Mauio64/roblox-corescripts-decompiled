local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 12
	return {
		userId = tostring(p1),
		character = p2,
		humanoid = p3
	}
end)
