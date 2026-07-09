local Parent = script:FindFirstAncestor("PlaceInfoRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		placesInfos = p1
	}
end)
