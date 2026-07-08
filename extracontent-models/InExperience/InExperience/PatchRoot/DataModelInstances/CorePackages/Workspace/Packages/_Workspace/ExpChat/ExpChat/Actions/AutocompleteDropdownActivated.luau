local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(b1: boolean) -- line: 9
	return {
		activated = b1
	}
end)
