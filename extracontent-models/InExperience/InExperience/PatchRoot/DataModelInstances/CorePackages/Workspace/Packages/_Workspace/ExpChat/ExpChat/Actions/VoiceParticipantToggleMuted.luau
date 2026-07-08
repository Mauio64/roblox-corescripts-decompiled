local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, b1: boolean) -- line: 11
	return {
		userId = tostring(p1),
		isMuted = b1
	}
end)
