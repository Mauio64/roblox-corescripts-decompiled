local Parent = script:FindFirstAncestor("GameProductInfoRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		gamesProductInfo = p1
	}
end)
