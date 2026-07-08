local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 10
	return {
		value = {
			preferredTransparency = p1.preferredTransparency or 1
		}
	}
end)
