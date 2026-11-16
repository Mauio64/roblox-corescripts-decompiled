local parent = script:FindFirstAncestor("GameProductInfoRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(gamesProductInfo)
	return { gamesProductInfo = gamesProductInfo }
end)
