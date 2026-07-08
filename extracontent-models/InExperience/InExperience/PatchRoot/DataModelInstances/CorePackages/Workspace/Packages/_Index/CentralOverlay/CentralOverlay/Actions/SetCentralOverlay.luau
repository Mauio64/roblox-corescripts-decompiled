local Parent = script:FindFirstAncestor("CentralOverlay").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 5
	return {
		overlayType = p1,
		arguments = p2,
		configs = p3
	}
end)
