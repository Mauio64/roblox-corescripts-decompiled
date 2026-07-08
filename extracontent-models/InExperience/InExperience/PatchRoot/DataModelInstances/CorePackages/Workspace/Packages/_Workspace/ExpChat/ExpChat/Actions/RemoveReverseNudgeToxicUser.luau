local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 10
	return {
		toxicUserId = tostring(p1)
	}
end)
