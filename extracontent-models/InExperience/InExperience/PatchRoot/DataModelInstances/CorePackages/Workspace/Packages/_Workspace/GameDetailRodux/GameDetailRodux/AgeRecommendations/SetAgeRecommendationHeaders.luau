local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(headerDisplayName: string?, headerDisplayNameShort: string?)
	return {
		headerDisplayName = headerDisplayName,
		headerDisplayNameShort = headerDisplayNameShort
	}
end)
