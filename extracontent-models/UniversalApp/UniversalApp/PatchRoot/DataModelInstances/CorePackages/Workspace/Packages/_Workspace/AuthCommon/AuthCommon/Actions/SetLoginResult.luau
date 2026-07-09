local Parent = script:FindFirstAncestor("AuthCommon").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		loginResult = p1
	}
end)
